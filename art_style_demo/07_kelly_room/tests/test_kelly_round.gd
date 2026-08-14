extends SceneTree
## Headless cases for every locked Kelly-room rule.

const Math := preload("res://art_style_demo/07_kelly_room/kelly_math.gd")
const Round := preload("res://art_style_demo/07_kelly_room/kelly_round.gd")
const Assets := preload("res://art_style_demo/07_kelly_room/kelly_assets.gd")

var _failed := 0
var _passed := 0


func _init() -> void:
	_run_all()
	print("Kelly tests: %d passed, %d failed" % [_passed, _failed])
	quit(1 if _failed > 0 else 0)


func _expect(cond: bool, name: String) -> void:
	if cond:
		_passed += 1
	else:
		_failed += 1
		print("FAIL: ", name)


func _rng(seed: int = 1) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	rng.state = seed
	return rng


func _fresh(total: int, seed: int = 1) -> RefCounted:
	var round: RefCounted = Round.new()
	round.begin_round(total, _rng(seed))
	return round


func _run_all() -> void:
	_test_opening_and_first_coin_odds()
	_test_first_round_payout()
	_test_random_odds_when_rich()
	_test_selection_and_count()
	_test_drop_and_deposit()
	_test_no_withdraw()
	_test_totals_and_kelly_constant()
	_test_sticker_toggle()
	_test_lever_success_and_fail()
	_test_empty_lever()
	_test_carry_then_lever()
	_test_bankruptcy_rescue()
	_test_return_to_one_coin_odds()
	_test_kelly_math_edges()
	_test_invariants()
	_test_phase_locks()
	_test_box_label()
	_test_repeated_deposits()
	_test_export_files_present()


func _test_opening_and_first_coin_odds() -> void:
	var r: RefCounted = _fresh(1, 99)
	_expect(r.round_total == 1, "start with one coin total")
	_expect(r.floor_count == 1, "the one coin starts on the floor")
	_expect(r.boxed_count == 0, "box empty at round start")
	_expect(r.selected_count == 0, "nothing selected at start")
	_expect(is_equal_approx(r.p, 1.0), "one-coin success rate is 100%")
	_expect(is_equal_approx(r.b, 1.0), "one-coin return rate is 1")
	_expect(Math.uses_first_coin_odds(1), "total 1 uses first-round odds")
	_expect(not Math.uses_first_coin_odds(2), "total 2 does not use first-round odds")
	var odds: Dictionary = Math.odds_for_total(1, _rng(7))
	_expect(is_equal_approx(float(odds["p"]), 1.0) and is_equal_approx(float(odds["b"]), 1.0),
			"odds_for_total ignores rng when total is 1")


func _test_first_round_payout() -> void:
	var r: RefCounted = _fresh(1)
	_expect(r.add_selection(1) == 1, "can select the only coin")
	_expect(r.deposit_selected() == 1, "can deposit the only coin")
	var result: Dictionary = r.pull_lever(0.0)
	_expect(bool(result["ok"]), "first-round lever ok")
	_expect(bool(result["success"]), "first-round invest always succeeds")
	_expect(int(result["stake"]) == 1, "first-round stake is 1")
	_expect(int(result["returned"]) == 2, "invest 1 at b=1 returns 2")
	_expect(int(result["new_total"]) == 2, "player now holds two coins")


func _test_random_odds_when_rich() -> void:
	var seen_non_first := false
	for seed in range(1, 40):
		var r: RefCounted = _fresh(5, seed)
		_expect(r.round_total == 5, "rich round keeps total 5 seed %d" % seed)
		if not is_equal_approx(r.p, 1.0) or not is_equal_approx(r.b, 1.0):
			seen_non_first = true
		_expect(r.p >= 0.20 and r.p <= 0.80, "random p in table seed %d" % seed)
		_expect(r.b >= 0.5 and r.b <= 3.0, "random b in table seed %d" % seed)
		_expect(not is_equal_approx(r.p, 1.0), "rich rounds never roll 100% p")
	_expect(seen_non_first, "at least one rich round differs from first-coin odds")


func _test_selection_and_count() -> void:
	var r: RefCounted = _fresh(8, 2)
	_expect(not r.show_selected_count(), "count hidden when hands empty")
	_expect(r.add_selection(3) == 3, "select 3 from floor")
	_expect(r.selected_count == 3, "selected count is 3")
	_expect(r.floor_count == 5, "floor decreased by 3")
	_expect(r.show_selected_count(), "count visible while carrying")
	_expect(r.add_selection(2) == 2, "further box-select adds to the carry")
	_expect(r.selected_count == 5, "carry is 5 after second select")
	_expect(r.add_selection(99) == 3, "cannot select more than remaining floor")
	_expect(r.selected_count == 8, "all coins can be carried")
	_expect(r.add_selection(1) == 0, "selecting with empty floor adds nothing")


func _test_drop_and_deposit() -> void:
	var r: RefCounted = _fresh(6, 3)
	r.add_selection(4)
	_expect(r.drop_selected() == 4, "drop returns carried count")
	_expect(r.selected_count == 0, "carry empty after drop")
	_expect(r.floor_count == 6, "dropped coins are on the floor again")
	_expect(not r.show_selected_count(), "count hidden after drop")
	r.add_selection(2)
	_expect(r.deposit_selected() == 2, "deposit swallows the carry")
	_expect(r.selected_count == 0, "carry empty after deposit")
	_expect(r.boxed_count == 2, "box holds deposited coins")
	_expect(r.floor_count == 4, "undeposited coins stay on the floor")
	_expect(r.deposit_selected() == 0, "deposit with empty hands does nothing")


func _test_no_withdraw() -> void:
	var r: RefCounted = _fresh(4, 4)
	r.add_selection(3)
	r.deposit_selected()
	_expect(not r.can_withdraw_from_box(), "box never allows withdraw")
	_expect(r.boxed_count == 3, "boxed coins stay boxed")
	_expect(r.floor_count == 1, "only undeposited coin is selectable")
	_expect(r.add_selection(3) == 1, "cannot select coins that are already boxed")


func _test_totals_and_kelly_constant() -> void:
	var r: RefCounted = _fresh(12, 5)
	var p0: float = r.p
	var b0: float = r.b
	var k0: int = r.recommended_stake()
	var t0: int = r.round_total
	r.add_selection(4)
	r.deposit_selected()
	r.add_selection(2)
	_expect(r.round_total == t0, "round total does not change when boxing coins")
	_expect(r.owned_sum() == t0, "floor+selected+boxed equals round total")
	_expect(is_equal_approx(r.p, p0) and is_equal_approx(r.b, b0), "odds stay fixed during the round")
	_expect(r.recommended_stake() == k0, "Kelly integer stays fixed after deposits")
	_expect(k0 == Math.kelly_coins(p0, b0, 12), "Kelly uses round total, not remaining floor")


func _test_sticker_toggle() -> void:
	var r: RefCounted = _fresh(10, 6)
	_expect(not r.sticker_revealed, "sticker starts covering the number")
	_expect(r.toggle_sticker() == true, "first click peels the sticker")
	_expect(r.sticker_revealed, "number is visible after peel")
	_expect(r.toggle_sticker() == false, "clicking the integer sticks it back")
	_expect(not r.sticker_revealed, "sticker covers again")
	r.toggle_sticker()
	var k: int = r.recommended_stake()
	r.add_selection(3)
	r.deposit_selected()
	_expect(r.recommended_stake() == k, "revealed Kelly number does not change mid-round")


func _test_lever_success_and_fail() -> void:
	var win: RefCounted = _fresh(10, 8)
	win.p = 0.60
	win.b = 2.0
	win.add_selection(3)
	win.deposit_selected()
	var won: Dictionary = win.pull_lever(0.0)
	_expect(bool(won["success"]), "roll 0 is success when p=0.60")
	_expect(int(won["stake"]) == 3, "stake is boxed amount")
	_expect(int(won["returned"]) == 9, "stake 3 at b=2 returns 9")
	_expect(int(won["new_total"]) == 16, "7 uninvested + 9 returned")
	_expect(win.boxed_count == 0, "box clears on invest")
	_expect(win.phase == Round.Phase.RESOLVED, "round is resolved after lever")

	var lose: RefCounted = _fresh(10, 8)
	lose.p = 0.60
	lose.b = 2.0
	lose.add_selection(3)
	lose.deposit_selected()
	var lost: Dictionary = lose.pull_lever(0.99)
	_expect(not bool(lost["success"]), "roll 0.99 fails when p=0.60")
	_expect(int(lost["returned"]) == 0, "failure returns nothing")
	_expect(int(lost["new_total"]) == 7, "only uninvested coins remain")
	_expect(int(lost["stake"]) == 3, "failed stake is still reported")


func _test_empty_lever() -> void:
	var r: RefCounted = _fresh(4, 9)
	var result: Dictionary = r.pull_lever(0.0)
	_expect(bool(result["ok"]), "empty box may still pull")
	_expect(int(result["stake"]) == 0, "empty pull has stake 0")
	_expect(int(result["returned"]) == 0, "empty pull returns 0")
	_expect(int(result["new_total"]) == 4, "wealth unchanged on empty pull")
	_expect(r.phase == Round.Phase.RESOLVED, "empty pull still ends the round")


func _test_carry_then_lever() -> void:
	var r: RefCounted = _fresh(6, 10)
	r.p = 0.0
	r.b = 1.0
	r.add_selection(2)
	r.deposit_selected()
	r.add_selection(3)
	var result: Dictionary = r.pull_lever(0.0)
	_expect(int(result["stake"]) == 2, "only boxed coins are invested")
	_expect(int(result["new_total"]) == 4, "carried coins drop as uninvested before resolve")
	_expect(r.selected_count == 0, "carry is cleared after lever")


func _test_bankruptcy_rescue() -> void:
	var r: RefCounted = _fresh(2, 11)
	r.p = 0.0
	r.b = 1.0
	r.add_selection(2)
	r.deposit_selected()
	var lost: Dictionary = r.pull_lever(0.0)
	_expect(bool(lost["broke"]), "losing all coins marks broke")
	_expect(int(lost["new_total"]) == 0, "player has zero after total loss")
	var nxt: Dictionary = r.start_next_round(_rng(11))
	_expect(bool(nxt["rescue_coin"]), "next round grants one coin from the outlet")
	_expect(int(nxt["total"]) == 1, "rescued round starts with one coin")
	_expect(bool(nxt["first_coin_odds"]), "rescue uses first-coin odds")
	_expect(is_equal_approx(r.p, 1.0) and is_equal_approx(r.b, 1.0), "rescued odds are 100% / 1")


func _test_return_to_one_coin_odds() -> void:
	var r: RefCounted = _fresh(3, 12)
	r.p = 0.0
	r.b = 2.0
	r.add_selection(2)
	r.deposit_selected()
	r.pull_lever(0.0)
	_expect(r.floor_count == 1, "one coin left after partial loss")
	var nxt: Dictionary = r.start_next_round(_rng(99))
	_expect(bool(nxt["first_coin_odds"]), "any 1-coin round uses first-coin odds")
	_expect(not bool(nxt["rescue_coin"]), "no outlet rescue when one coin remains")
	_expect(is_equal_approx(r.p, 1.0), "p forced to 1 when only one coin")


func _test_kelly_math_edges() -> void:
	_expect(Math.kelly_fraction(1.0, 1.0) == 1.0, "sure bet with b=1 is 100%")
	_expect(Math.kelly_coins(1.0, 1.0, 1) == 1, "first-round Kelly is 1")
	_expect(Math.kelly_coins(0.60, 2.0, 12) == 5, "0.6-0.4/2 = 0.4 of 12 rounds to 5")
	_expect(Math.kelly_fraction(0.10, 1.0) == 0.0, "negative Kelly clamps to 0")
	_expect(Math.kelly_coins(0.10, 1.0, 20) == 0, "negative Kelly recommends 0 coins")
	_expect(Math.returned_coins(1, 1.0, true) == 2, "b=1 doubles the stake")
	_expect(Math.returned_coins(5, 1.0, false) == 0, "failure returns 0")
	_expect(Math.returned_coins(0, 3.0, true) == 0, "zero stake returns 0")
	_expect(Math.kelly_coins(0.5, 1.0, 0) == 0, "Kelly of 0 wealth is 0")


func _test_invariants() -> void:
	var r: RefCounted = _fresh(9, 13)
	r.add_selection(4)
	r.deposit_selected()
	r.add_selection(2)
	_expect(r.owned_sum() == r.round_total, "counts partition the round total")
	_expect(r.floor_count + r.selected_count + r.boxed_count == 9, "9 = floor+carry+box")


func _test_phase_locks() -> void:
	var r: RefCounted = _fresh(5, 14)
	r.pull_lever(0.0)
	_expect(r.add_selection(1) == 0, "cannot select after resolve")
	_expect(r.deposit_selected() == 0, "cannot deposit after resolve")
	_expect(r.drop_selected() == 0, "cannot drop after resolve")
	var revealed: bool = r.sticker_revealed
	r.toggle_sticker()
	_expect(r.sticker_revealed == revealed, "sticker frozen after resolve")
	var again: Dictionary = r.pull_lever(0.0)
	_expect(not bool(again["ok"]), "cannot pull twice in one round")
	var early: RefCounted = _fresh(3, 15)
	var nxt: Dictionary = early.start_next_round(_rng())
	_expect(not bool(nxt["ok"]), "cannot start next round before resolve")


func _test_box_label() -> void:
	var r: RefCounted = _fresh(12, 16)
	_expect(r.box_label() == "0/12", "label starts 0/total")
	r.add_selection(3)
	_expect(r.box_label() == "0/12", "carry is not yet boxed")
	r.deposit_selected()
	_expect(r.box_label() == "3/12", "label is boxed/total")
	r.add_selection(2)
	r.deposit_selected()
	_expect(r.box_label() == "5/12", "repeated deposits raise the numerator only")


func _test_repeated_deposits() -> void:
	var r: RefCounted = _fresh(7, 17)
	r.add_selection(1)
	r.deposit_selected()
	r.add_selection(1)
	r.deposit_selected()
	r.add_selection(1)
	r.deposit_selected()
	_expect(r.boxed_count == 3, "three separate deposits accumulate")
	_expect(r.floor_count == 4, "remaining floor after three deposits")
	_expect(r.round_total == 7, "total still 7")


func _test_export_files_present() -> void:
	_expect(Assets.REQUIRED_PATHS.size() == 8, "eight Kelly-room export paths")
	for path in Assets.REQUIRED_PATHS:
		_expect(FileAccess.file_exists(path), "export exists %s" % path)
	_expect(FileAccess.file_exists(Assets.WOOD_WALL), "issue 29 wall tile export exists")
	_expect(Assets.tex(Assets.WOOD_WALL) != null, "issue 29 wall tile loads")

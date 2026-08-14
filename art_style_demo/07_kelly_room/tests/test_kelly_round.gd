extends SceneTree
## Headless cases for every locked Kelly-room rule.

const Math := preload("res://art_style_demo/07_kelly_room/kelly_math.gd")
const Round := preload("res://art_style_demo/07_kelly_room/kelly_round.gd")
const Assets := preload("res://art_style_demo/07_kelly_room/kelly_assets.gd")
const Fit := preload("res://art_style_demo/07_kelly_room/kelly_fit.gd")
const Marker := preload("res://art_style_demo/07_kelly_room/kelly_marker.gd")

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
	_test_fit_list_loads()
	_test_art_pipeline_audit()
	_test_marker_digits_atlas()


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


func _test_fit_list_loads() -> void:
	var fit := Fit.new()
	_expect(fit.ok(), "fit list and art-style gates parse")
	for problem in fit.errors:
		print("  fit: ", problem)
	_expect(fit.items.size() == 13, "thirteen fit-list items")
	_expect(fit.tolerance == 0.03, "default tolerance 0.03")
	_expect(is_equal_approx(fit.luma_mean_min, 30.0), "mean gate min 30")
	_expect(is_equal_approx(fit.luma_mean_max, 50.0), "mean gate max 50")
	_expect(is_equal_approx(fit.edge_p90_max, 0.40), "edge/P90 gate 0.40")
	if fit.items.has("glass"):
		var g: Dictionary = fit.items["glass"]
		_expect(is_equal_approx(g["centre"].x, 0.520), "glass centre x")
		_expect(is_equal_approx(g["size"].x, 0.650), "glass width")
		_expect(g["whole"] == true, "glass must sit whole in frame")
	if fit.items.has("box_marker"):
		_expect(is_equal_approx(fit.items["box_marker"]["text_height"], 0.080),
				"box marker height is 0.080 of the frame")


func _test_art_pipeline_audit() -> void:
	_expect(Assets.REQUIRED.size() == 20, "twenty required exports for issue 32")
	# Submodule is pinned past the issue_32 fan-in: every required export must
	# load, and audit() must stay silent rather than report a false greybox.
	var report := Assets.audit()
	_expect(report.is_empty(), "audit is clean when every required export is present")
	_expect(Assets.tex(Assets.IRON_APRON) != null, "iron_apron loads from issue_32")
	_expect(Assets.tex(Assets.OUTLET_OPEN) != null, "outlet_open loads from issue_32")
	_expect(Assets.tex(Assets.WOOD_WALL) != null, "wood_plank_wall loads from issue_32")
	_expect(Assets.tex(Assets.BEAM) != null, "beam loads from issue_32")
	var beam := Assets.tex(Assets.BEAM)
	if beam != null:
		_expect(beam.get_width() == 64 and beam.get_height() == 64, "beam is 64×64")
	_expect(Assets.tex(Assets.WALL_LANTERN) != null, "wall_lantern loads from issue_32")
	var wall_lantern := Assets.tex(Assets.WALL_LANTERN)
	if wall_lantern != null:
		_expect(wall_lantern.get_width() == 32 and wall_lantern.get_height() == 48,
				"wall_lantern is 32×48")
	var fit_lantern := Fit.new()
	if fit_lantern.items.has("lantern"):
		var Ln: Dictionary = fit_lantern.items["lantern"]
		_expect(is_equal_approx(Ln["size"].x, 0.072) and is_equal_approx(Ln["size"].y, 0.345),
				"lantern fit size is 0.072×0.345")
	_expect(Assets.tex(Assets.COIN_EDGE) != null, "coin_edge loads from issue_32")
	var coin_edge := Assets.tex(Assets.COIN_EDGE)
	if coin_edge != null:
		_expect(coin_edge.get_width() == 16 and coin_edge.get_height() == 16,
				"coin_edge is 16×16")
	var coin_flat := Assets.tex(Assets.COIN_FLAT)
	_expect(coin_flat != null, "floor coin_flat still loads (not replaced by coin_edge)")
	if coin_edge != null and coin_flat != null:
		_expect(coin_edge != coin_flat, "pooled edge coin is not the floor flat coin")
	_expect(Assets.tex(Assets.WHITEBOARD) != null, "whiteboard loads from issue_32")
	var whiteboard := Assets.tex(Assets.WHITEBOARD)
	if whiteboard != null:
		_expect(whiteboard.get_width() == 64 and whiteboard.get_height() == 48,
				"whiteboard is 64×48")
	var fit_board := Fit.new()
	if fit_board.items.has("whiteboard"):
		var B: Dictionary = fit_board.items["whiteboard"]
		_expect(is_equal_approx(B["size"].x, 0.218) and is_equal_approx(B["size"].y, 0.165),
				"whiteboard fit size is 0.218×0.165")
	_expect(Assets.tex(Assets.LEVER) != null, "lever loads from issue_32")
	var lever := Assets.tex(Assets.LEVER)
	if lever != null:
		_expect(lever.get_width() == 64 and lever.get_height() == 64, "lever is 64×64")
	_expect(Assets.tex(Assets.LEVER_DOWN) != null, "lever_down loads from issue_32")
	var lever_down := Assets.tex(Assets.LEVER_DOWN)
	if lever_down != null:
		_expect(lever_down.get_width() == 64 and lever_down.get_height() == 64,
				"lever_down is 64×64")
	var fit_lever := Fit.new()
	if fit_lever.items.has("lever"):
		var L: Dictionary = fit_lever.items["lever"]
		_expect(is_equal_approx(L["size"].x, 0.090) and is_equal_approx(L["size"].y, 0.355),
				"lever fit size is 0.090×0.355")
		var ball_top: float = L["centre"].y - 0.5 * L["size"].y
		_expect(absf(ball_top - 0.545) <= 0.03, "lever ball top y ≈ 0.545 from fit box")
	var post := Assets.tex(Assets.POST)
	_expect(post != null, "post loads from issue_32")
	if post != null:
		_expect(post.get_width() == 32 and post.get_height() == 48, "post is 32×48")
	var outlet_closed := Assets.tex(Assets.OUTLET_CLOSED)
	_expect(outlet_closed != null, "outlet_closed loads from issue_32")
	if outlet_closed != null:
		_expect(outlet_closed.get_width() == 64 and outlet_closed.get_height() == 48,
				"outlet_closed is 64×48")
	var side_window := Assets.tex(Assets.SIDE_WINDOW)
	_expect(side_window != null, "side_window loads from issue_32")
	if side_window != null:
		_expect(side_window.get_width() == 32 and side_window.get_height() == 48,
				"side_window is 32×48")
	_expect(Assets.tex(Assets.ISSUE + "does_not_exist.png") == null,
			"a missing path returns null instead of a fake texture")


func _test_marker_digits_atlas() -> void:
	var tex := Assets.tex(Assets.MARKER_DIGITS)
	_expect(tex != null, "marker_digits export loads")
	if tex != null:
		_expect(tex.get_width() == 176 and tex.get_height() == 16,
				"marker_digits atlas is 176×16")
	var host := Node3D.new()
	var digits: RefCounted = Marker.new()
	digits.build(host, "Digits", 0.08)
	_expect(digits.available(), "marker helper accepts the atlas")
	digits.set_text("0/12")
	_expect(digits.root.get_child_count() == 4, "0/12 draws four glyphs")
	digits.set_text("7")
	_expect(digits.root.get_child_count() == 1, "single digit draws one glyph")
	digits.set_text("ab.3")
	_expect(digits.root.get_child_count() == 1, "non-digit characters are skipped")
	host.free()

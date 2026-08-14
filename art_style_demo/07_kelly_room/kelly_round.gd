extends RefCounted
## One-round source of truth for the Kelly gambling demo.

const Math := preload("res://art_style_demo/07_kelly_room/kelly_math.gd")

enum Phase { PLAYING, RESOLVED }

var phase: int = Phase.PLAYING
var round_total: int = 0
var floor_count: int = 0
var selected_count: int = 0
var boxed_count: int = 0
var p: float = Math.FIRST_COIN_P
var b: float = Math.FIRST_COIN_B
var sticker_revealed: bool = false
var last_success: bool = false
var last_returned: int = 0
var rescue_pending: bool = false


func owned_sum() -> int:
	return floor_count + selected_count + boxed_count


func begin_round(total: int, rng: RandomNumberGenerator) -> void:
	var start := maxi(total, 0)
	rescue_pending = false
	if start == 0:
		start = 1
		rescue_pending = true
	round_total = start
	floor_count = start
	selected_count = 0
	boxed_count = 0
	sticker_revealed = false
	last_success = false
	last_returned = 0
	phase = Phase.PLAYING
	var odds: Dictionary = Math.odds_for_total(round_total, rng)
	p = float(odds["p"])
	b = float(odds["b"])


func box_label() -> String:
	return "%d/%d" % [boxed_count, round_total]


func recommended_stake() -> int:
	return Math.kelly_coins(p, b, round_total)


func show_selected_count() -> bool:
	return selected_count > 0 and phase == Phase.PLAYING


func add_selection(n: int) -> int:
	if phase != Phase.PLAYING or n <= 0:
		return 0
	var added := mini(n, floor_count)
	floor_count -= added
	selected_count += added
	return added


func drop_selected() -> int:
	if phase != Phase.PLAYING:
		return 0
	var n := selected_count
	floor_count += selected_count
	selected_count = 0
	return n


func deposit_selected() -> int:
	if phase != Phase.PLAYING or selected_count <= 0:
		return 0
	var n := selected_count
	boxed_count += selected_count
	selected_count = 0
	return n


func toggle_sticker() -> bool:
	if phase != Phase.PLAYING:
		return sticker_revealed
	sticker_revealed = not sticker_revealed
	return sticker_revealed


func can_withdraw_from_box() -> bool:
	return false


func pull_lever(roll: float) -> Dictionary:
	if phase != Phase.PLAYING:
		return {"ok": false, "reason": "not_playing"}
	if selected_count > 0:
		drop_selected()
	var stake := boxed_count
	boxed_count = 0
	var success := roll < p
	var returned := Math.returned_coins(stake, b, success)
	var uninvested := floor_count + selected_count
	floor_count = uninvested + returned
	selected_count = 0
	last_success = success
	last_returned = returned
	phase = Phase.RESOLVED
	return {
		"ok": true,
		"success": success,
		"stake": stake,
		"returned": returned,
		"new_total": floor_count,
		"broke": floor_count == 0,
	}


func start_next_round(rng: RandomNumberGenerator) -> Dictionary:
	if phase != Phase.RESOLVED:
		return {"ok": false, "reason": "not_resolved"}
	var next_total := floor_count
	begin_round(next_total, rng)
	return {
		"ok": true,
		"total": round_total,
		"rescue_coin": rescue_pending,
		"first_coin_odds": Math.uses_first_coin_odds(round_total),
	}

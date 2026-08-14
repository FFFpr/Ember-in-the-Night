extends RefCounted
## Pure Kelly-criterion helpers for the gambling demo. No Node types.

const FIRST_COIN_P := 1.0
const FIRST_COIN_B := 1.0

const P_STEPS: Array[float] = [
	0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80,
]
const B_STEPS: Array[float] = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0]


static func uses_first_coin_odds(total: int) -> bool:
	return total <= 1


static func kelly_fraction(p: float, b: float) -> float:
	if b <= 0.0:
		return 0.0
	var q := 1.0 - p
	return maxf(0.0, p - q / b)


static func kelly_coins(p: float, b: float, total: int) -> int:
	if total <= 0:
		return 0
	var raw := kelly_fraction(p, b) * float(total)
	return clampi(int(floor(raw + 0.5)), 0, total)


static func returned_coins(stake: int, b: float, success: bool) -> int:
	if not success or stake <= 0:
		return 0
	return int(floor(float(stake) * (1.0 + b) + 0.5))


static func roll_odds(rng: RandomNumberGenerator) -> Dictionary:
	var p: float = P_STEPS[rng.randi_range(0, P_STEPS.size() - 1)]
	var b: float = B_STEPS[rng.randi_range(0, B_STEPS.size() - 1)]
	return {"p": p, "b": b}


static func odds_for_total(total: int, rng: RandomNumberGenerator) -> Dictionary:
	if uses_first_coin_odds(total):
		return {"p": FIRST_COIN_P, "b": FIRST_COIN_B}
	return roll_odds(rng)

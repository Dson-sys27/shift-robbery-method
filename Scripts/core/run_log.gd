class_name RunLog
extends Resource
## Record of a single heist: loot taken and errors committed.
## Filled during HEIST and evaluated when the player escapes (GDD 5.1.3).

## Errors in commit order. Each entry: { "id": StringName, "weight": float }.
@export var errors: Array[Dictionary] = []
## Total value of the loot taken during the heist.
@export var stolen_value := 0


func add_error(id: StringName, weight: float) -> void:
	errors.append({"id": id, "weight": weight})


func add_loot(value: int) -> void:
	stolen_value += value


func total_error_weight() -> float:
	var total := 0.0
	for e in errors:
		total += e.weight
	return total


## Whether the heist counts as a success.
## TODO: success threshold is not defined in the GDD yet (P82, P83).
func is_success() -> bool:
	return true  # S2

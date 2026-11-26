extends Node
## Autoload that owns the current run and drives the phase flow (GDD 4.1):
## SEARCH -> HEIST -> INVEST -> next day, until the last day.
## Phase scenes only call advance(), fail_run() or spend(); they never change scenes themselves.

signal phase_changed(phase: Phase)
signal money_changed(money: int)

enum Phase { MENU, SEARCH, HEIST, INVEST, GAME_OVER, RUN_END }

const MIN_DAYS := 5
const MAX_DAYS := 9
const PLACEHOLDER := "res://Scenes/phases/phase_placeholder.tscn"

## Scene shown for each phase. Replace a placeholder entry when its real scene exists.
const PHASE_SCENES := {
	Phase.MENU: PLACEHOLDER,
	Phase.SEARCH: PLACEHOLDER,
	Phase.HEIST: PLACEHOLDER,
	Phase.INVEST: PLACEHOLDER,
	Phase.GAME_OVER: PLACEHOLDER,
	Phase.RUN_END: PLACEHOLDER,
}

var phase := Phase.MENU
var day := 0
var total_days := 0
var run_seed := 0
## Log of the heist in progress; reset at the start of every day.
var run_log := RunLog.new()
var money := 0:
	set(value):
		money = value
		money_changed.emit(money)


## Starts a new run. Pass a seed to reproduce a run; 0 picks a random one.
func start_run(new_seed := 0) -> void:
	run_seed = new_seed if new_seed != 0 else randi()
	seed(run_seed)
	total_days = randi_range(MIN_DAYS, MAX_DAYS)  # TODO: random, fixed or chosen? (P85 / S1)
	day = 1
	money = 0
	_begin_day()


## Moves to the next phase of the loop.
func advance() -> void:
	match phase:
		Phase.SEARCH:
			_set_phase(Phase.HEIST)
		Phase.HEIST:
			# Player reached an exit. TODO: how errors affect the result (P95 / S3).
			if run_log.is_success():
				money += run_log.stolen_value
			_set_phase(Phase.INVEST)
		Phase.INVEST:
			if day >= total_days:
				_set_phase(Phase.RUN_END)
			else:
				day += 1
				_begin_day()
		Phase.GAME_OVER, Phase.RUN_END:
			_set_phase(Phase.MENU)


## Player was captured: the run is lost (GDD 4.4).
func fail_run() -> void:
	_set_phase(Phase.GAME_OVER)


## Spends money in the Invest phase. Returns false if there is not enough.
func spend(amount: int) -> bool:
	if amount > money:
		return false
	money -= amount
	return true


func _begin_day() -> void:
	run_log = RunLog.new()
	_set_phase(Phase.SEARCH)


func _set_phase(new_phase: Phase) -> void:
	phase = new_phase
	phase_changed.emit(phase)
	get_tree().change_scene_to_file.call_deferred(PHASE_SCENES[phase])

extends Control
## Temporary screen for any phase without a real scene yet.
## Shows the run state and the buttons that move the flow forward.

@onready var _title: Label = $Center/Box/Title
@onready var _info: Label = $Center/Box/Info
@onready var _buttons: VBoxContainer = $Center/Box/Buttons


func _ready() -> void:
	var phase := RunManager.phase
	_title.text = str(RunManager.Phase.keys()[phase]).capitalize()
	_info.text = _describe_run()
	match phase:
		RunManager.Phase.MENU:
			_add_button("New run", RunManager.start_run)
		RunManager.Phase.SEARCH:
			_add_button("Start heist", RunManager.advance)
		RunManager.Phase.HEIST:
			_add_button("Escape with test loot (+100)", _escape_with_test_loot)
			_add_button("Get caught", RunManager.fail_run)
		RunManager.Phase.INVEST:
			_add_button("Next day", RunManager.advance)
		RunManager.Phase.GAME_OVER, RunManager.Phase.RUN_END:
			_add_button("Back to menu", RunManager.advance)


func _describe_run() -> String:
	if RunManager.phase == RunManager.Phase.MENU:
		return "SHIFT: Methods for Robbery"
	var log := RunManager.run_log
	return "Day %d / %d   ·   Money: %d\nLoot this heist: %d   ·   Errors: %d" % [
		RunManager.day, RunManager.total_days, RunManager.money,
		log.stolen_value, log.errors.size()]


func _escape_with_test_loot() -> void:
	RunManager.run_log.add_loot(100)
	RunManager.advance()


func _add_button(text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(func() -> void: action.call())
	_buttons.add_child(button)

extends InteractivePref

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var p : float = 0.01
@onready var racha : int = 0

func _ready() -> void:
	sprite.play("off")
func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("shift_interact")):
		if(collision_state == S_M_STATE.COLLIDING):
			var temp_p = randf()
			if(temp_p < p):
				sprite.play("winner")
				GameManager.bounty += (randi() % 250) * racha
				p = 0.01
				print(str(GameManager.bounty))
			else:
				sprite.play("loser")
				racha += 1
				p += 0.005
			await sprite.animation_finished
			sprite.play("off")

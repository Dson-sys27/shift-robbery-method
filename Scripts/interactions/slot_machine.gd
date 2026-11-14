extends StaticBody2D

@onready var trigger_area : Area2D = $Area2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_state : S_M_STATE = S_M_STATE.AWAY
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var p : float = 0.01
@onready var racha : int = 0
enum S_M_STATE{
	AWAY,
	COLLIDING
}
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
				
func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body == player):
		collision_state = S_M_STATE.COLLIDING

func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body == player):
		collision_state = S_M_STATE.AWAY

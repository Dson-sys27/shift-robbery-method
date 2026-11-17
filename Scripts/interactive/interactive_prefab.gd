class_name InteractivePref
extends StaticBody2D

@onready var trigger_area : Area2D = $Area2D
@onready var sprites : Array[Node2D]
@onready var collision_state : S_M_STATE = S_M_STATE.AWAY
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
enum S_M_STATE{
	AWAY,
	COLLIDING
}
func _ready() -> void:
	pass 
func _input(event: InputEvent) -> void:
	pass
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body == player):
		collision_state = S_M_STATE.COLLIDING
func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body == player):
		collision_state = S_M_STATE.AWAY

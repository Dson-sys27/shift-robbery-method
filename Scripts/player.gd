extends CharacterBody2D
## Top-down player controller with 8-directional movement.
## Expects animations named "idle_<dir>" and "walk_<dir>" (right, up, left, down).

## Movement speed in pixels per second.
@export var speed := 80.0

## Last facing direction, used to pick the idle animation.
var facing := "down"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()

	if input != Vector2.ZERO:
		facing = _direction_from(input)
		sprite.play("walk_" + facing)
	else:
		sprite.play("idle_" + facing)


## Returns the dominant cardinal direction of [param v].
func _direction_from(v: Vector2) -> String:
	var horizontal := "right" if v.x > 0.0 else "left"
	var vertical := "down" if v.y > 0.0 else "up"
	if absf(v.x) > absf(v.y):
		return horizontal
	if absf(v.y) > absf(v.x):
		return vertical
	# Exact diagonal: keep the current facing if still valid to avoid flickering.
	return facing if facing in [horizontal, vertical] else horizontal

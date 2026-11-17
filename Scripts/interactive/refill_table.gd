extends InteractivePref

@onready var drink : TileMapLayer = $drink
@onready var particle_system : GPUParticles2D = $GPUParticles2D
@onready var used : bool = false
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if(Input.is_action_pressed("e_interact")):
		if(collision_state == S_M_STATE.COLLIDING and not used):
			drink.visible = false
			particle_system.emitting = true
			used = true

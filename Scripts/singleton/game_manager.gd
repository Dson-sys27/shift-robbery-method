extends Node
#Var
var map_size : int
var exp_mult : float
var game_state : GAME_STATE
#Const
const MIN_SIZE : int = 20
const TILE_SIZE: int  = 16
const TILE_PATTERNS : Dictionary = {
	"floor" : 0,
	"bottom_wall" : 1,
	"right_wall" : 4,
	"left_wall" : 5,
	"right_corner" : 6,
	"left_corner" : 7
}
enum GAME_STATE{
	starting,
	searching,
	heist,
	improvising,
	end_match
}
#Nodes
@onready var casino_layer : TileMapLayer = get_tree().get_first_node_in_group("scenario")
@onready var player : CharacterBody2D = $Player
#Source
func _ready() -> void:
	#Initializing when first round starts
	while(game_state == GAME_STATE.starting):
		check_if_loaded()
	map_size = MIN_SIZE + (randi() % 11)
	exp_mult = map_size / 10
	game_state = GAME_STATE.starting
	create_terrain()
func _process(delta: float) -> void:
	pass	
func create_terrain() -> void:
	for x in map_size:	
		for y in map_size:
			var tile_pos : Vector2i
			var pattern_index : int
			var pattern : TileMapPattern
			tile_pos = Vector2i(x, y)
			pattern_index = get_pattern_from_pos(x, y)
			pattern = casino_layer.tile_set.get_pattern(pattern_index)
			if(pattern_index != -1):
				casino_layer.set_pattern(tile_pos, pattern)
func check_if_loaded() -> void:
	if(
		casino_layer
		and player
	):
		pass
	else:
		game_state = GAME_STATE.searching
func get_pattern_from_pos(x : int, y : int) -> int:
	var index : int = 0
	if((x == map_size - 1)):
		if(y != 0):
			index = TILE_PATTERNS.get("right_wall")
		else:
			index = TILE_PATTERNS.get("right_corner")
	elif((x == 0)):
		if(y != 0):
			index = TILE_PATTERNS.get("left_wall")
		else:
			index = TILE_PATTERNS.get("left_corner")
	elif(y == 0 and x > 0 and x < map_size - 1):
			index = TILE_PATTERNS.get("bottom_wall") 
	elif(y > 3):
		index = TILE_PATTERNS.get("floor")
	else:
		index = -1
	return index

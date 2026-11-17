extends Node

@onready var map_size = GameManager.map_size
@onready var casino_layer : TileMapLayer = get_tree().get_first_node_in_group("scenario")
const TILE_SIZE = 16	
const TILE_PATTERNS : Dictionary = {
	"floor" : 0,
	"bottom_wall" : 1,
	"right_wall" : 4,
	"left_wall" : 5,
	"right_corner" : 6,
	"left_corner" : 7
}

#Solución dibujado en una capa 
#func create_terrain() -> void:
	#for x in map_size:	
		#for y in map_size:
			#var tile_pos : Vector2i
			#var pattern_index : int
			#var pattern : TileMapPattern
			#tile_pos = Vector2i(x, y)
			#pattern_index = get_pattern_from_pos(x, y)
			#if(pattern_index != -1):
				#pattern = casino_layer.tile_set.get_pattern(pattern_index)
				#casino_layer.set_pattern(tile_pos, pattern)

#func get_pattern_from_pos(x : int, y : int) -> int:
	#var index : int = 0
	#if((x == map_size - 1)):
		#if(y != 0):
			#index = TILE_PATTERNS.get("right_wall")
		#else:
			#index = TILE_PATTERNS.get("right_corner")
	#elif((x == 0)):
		#if(y != 0):
			#index = TILE_PATTERNS.get("left_wall")
		#else:
			#index = TILE_PATTERNS.get("left_corner")
	#elif(y == 0 and x > 0 and x < map_size - 1):
			#index = TILE_PATTERNS.get("bottom_wall") 
	#elif(y > 3):
		#index = TILE_PATTERNS.get("floor")
	#else:
		#index = -1
	#return index
	
#Solución dibujado en varias capas
func draw_terrain():
	floor_layer()
	side_walls_layer()
	bottom_wall_layer()
	
func floor_layer():
	var pattern : TileMapPattern
	pattern = casino_layer.tile_set.get_pattern(TILE_PATTERNS.get("floor"))
	for x in map_size:	
		for y in map_size:
			casino_layer.set_pattern(Vector2(x, y), pattern)

func bottom_wall_layer():
	var pattern : TileMapPattern
	var pattern_index : int
	for x in map_size + 1:
		if(x == 0):
			pattern_index = TILE_PATTERNS.get("left_corner")
		elif(x == map_size):
			pattern_index = TILE_PATTERNS.get("right_corner")
		else:
			pattern_index = TILE_PATTERNS.get("bottom_wall")
		pattern = casino_layer.tile_set.get_pattern(pattern_index)
		casino_layer.set_pattern(Vector2(x, 0), pattern)

func side_walls_layer():
	var pattern_1 : TileMapPattern
	var pattern_2 : TileMapPattern
	var index_1 : int
	var index_2 : int
	index_1 = TILE_PATTERNS.get("left_wall")
	index_2 = TILE_PATTERNS.get("right_wall")
	pattern_1 = casino_layer.tile_set.get_pattern(index_1)
	pattern_2 = casino_layer.tile_set.get_pattern(index_2)
	for y in map_size:
		casino_layer.set_pattern(Vector2(0, y), pattern_1)
		casino_layer.set_pattern(Vector2(map_size, y), pattern_2)
	

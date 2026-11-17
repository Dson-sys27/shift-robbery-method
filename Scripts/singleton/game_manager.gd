extends Node
#Var
var map_size : int
var exp_mult : float
var game_state : GAME_STATE
var bounty : int
var noise : FastNoiseLite
#Const
const MIN_SIZE : int = 20
enum GAME_STATE{
	starting,
	searching,
	heist,
	improvising,
	end_match
}
const SLOT_MACHINE : PackedScene = preload("res://Scenes/prefabs/animated/slot_machine.tscn")
const  REFILL_TABLE : PackedScene = preload("res://Scenes/prefabs/animated/refill_table.tscn")
#Nodes
@onready var casino_layer : TileMapLayer = get_tree().get_first_node_in_group("scenario")
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
#Source
func _ready() -> void:
	#Initializing when first round starts
	while(game_state == GAME_STATE.starting):
		check_if_loaded()
	map_size = get_new_size()
	TerrainGenerator.map_size = map_size
	exp_mult = get_new_exp_mult()
	game_state = GAME_STATE.starting
	bounty = 0
	TerrainGenerator.draw_terrain()

func _process(delta: float) -> void:
	pass		
func check_if_loaded() -> void:
	if(
		casino_layer
		and player
	):
		game_state = GAME_STATE.searching
	else:
		pass		
		
func get_new_size() -> int:
	return MIN_SIZE + (randi() % 11)
	
func get_new_exp_mult() -> float:
	return map_size / 10
	
func next_stage() -> void:
	game_state = GAME_STATE.starting

extends CharacterBody2D

const CELL_SIZE := 16

enum CellState { WALKABLE, WALL, PLAYER }
enum AIState { ROAMING, DETECT_DELAY, MOVING_TO_TARGET, RECHECK_COOLDOWN }

@export var move_speed := 70.0
@export var detection_radius_px := 112.0 # 7 celdas de 16px
@export var reaction_delay := 0.35        # Pausa al detectar antes de avanzar
@export var recheck_interval := 0.6      # Espera tras llegar antes de volver a comprobar
@export var max_roam_cells := 4
@export var roam_wait_time := 1.2
@export var use_dijkstra := false        # false = A*, true = Dijkstra

var grid: Array = []
var grid_width := 0
var grid_height := 0

var spawn_cell := Vector2i.ZERO
var player_cell := Vector2i(-1, -1)
var locked_target_cell := Vector2i(-1, -1)
var current_path: Array[Vector2i] = []

var state: AIState = AIState.ROAMING
var state_timer := 0.0
var roam_timer := 0.0

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	init_demo_grid(40, 25)
	spawn_cell = world_to_cell(global_position)
	pick_roam_target()

func init_demo_grid(w: int, h: int) -> void:
	grid_width = w
	grid_height = h
	grid.clear()
	for y in range(h):
		var row: Array = []
		for x in range(w):
			if x == 0 or y == 0 or x == w - 1 or y == h - 1:
				row.append(CellState.WALL)
			else:
				row.append(CellState.WALKABLE)
		grid.append(row)

func is_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < grid_width and cell.y < grid_height

func get_cell_state(cell: Vector2i) -> CellState:
	if not is_in_bounds(cell):
		return CellState.WALL
	return grid[cell.y][cell.x]

func is_walkable(cell: Vector2i) -> bool:
	return is_in_bounds(cell) and get_cell_state(cell) != CellState.WALL

func world_to_cell(pos: Vector2) -> Vector2i:
	return Vector2i(floori(pos.x / CELL_SIZE), floori(pos.y / CELL_SIZE))

func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2((cell.x + 0.5) * CELL_SIZE, (cell.y + 0.5) * CELL_SIZE)

func is_rect_walkable(rect: Rect2) -> bool:
	var top_left := world_to_cell(rect.position)
	var bottom_right := world_to_cell(rect.end - Vector2(0.01, 0.01))
	for y in range(top_left.y, bottom_right.y + 1):
		for x in range(top_left.x, bottom_right.x + 1):
			if not is_walkable(Vector2i(x, y)):
				return false
	return true

func update_player_cell() -> void:
	if player == null:
		return
	if is_in_bounds(player_cell) and get_cell_state(player_cell) == CellState.PLAYER:
		grid[player_cell.y][player_cell.x] = CellState.WALKABLE

	var candidate := world_to_cell(player.global_position)
	var player_rect := Rect2(player.global_position - Vector2(6, 6), Vector2(12, 12))
	if is_walkable(candidate) and is_rect_walkable(player_rect):
		player_cell = candidate
		grid[player_cell.y][player_cell.x] = CellState.PLAYER

func can_see_player() -> bool:
	if player == null or not is_in_bounds(player_cell):
		return false
	return global_position.distance_to(player.global_position) <= detection_radius_px

func trace_path(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	if use_dijkstra:
		return find_path_dijkstra(start, goal)
	return find_path_astar(start, goal)

func _physics_process(delta: float) -> void:
	update_player_cell()
	var my_cell := world_to_cell(global_position)

	match state:
		AIState.ROAMING:
			if can_see_player():
				start_detect_delay()
				return

			if current_path.is_empty():
				roam_timer -= delta
				if roam_timer <= 0.0:
					pick_roam_target()
					roam_timer = roam_wait_time

			follow_path()

		AIState.DETECT_DELAY:
			# Se detiene brevemente antes de ejecutar la ruta hacia la posición fijada
			velocity = Vector2.ZERO
			move_and_slide()
			state_timer -= delta
			if state_timer <= 0.0:
				current_path = trace_path(my_cell, locked_target_cell)
				state = AIState.MOVING_TO_TARGET

		AIState.MOVING_TO_TARGET:
			follow_path()
			# Al terminar la ruta fijada, pasa a esperar antes de volver a comprobar
			if current_path.is_empty():
				state = AIState.RECHECK_COOLDOWN
				state_timer = recheck_interval

		AIState.RECHECK_COOLDOWN:
			velocity = Vector2.ZERO
			move_and_slide()
			state_timer -= delta
			if state_timer <= 0.0:
				if can_see_player():
					start_detect_delay()
				else:
					current_path.clear()
					state = AIState.ROAMING
					pick_roam_target()

func start_detect_delay() -> void:
	locked_target_cell = player_cell
	current_path.clear()
	state = AIState.DETECT_DELAY
	state_timer = reaction_delay

func pick_roam_target() -> void:
	var my_cell := world_to_cell(global_position)
	for _i in range(25):
		var offset := Vector2i(
			randi_range(-max_roam_cells, max_roam_cells),
			randi_range(-max_roam_cells, max_roam_cells)
		)
		var target := spawn_cell + offset
		if is_walkable(target) and target != my_cell:
			var path := trace_path(my_cell, target)
			if not path.is_empty():
				current_path = path
				return

func follow_path() -> void:
	if current_path.is_empty():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_cell := current_path[0]
	var target_pos := cell_to_world(next_cell)
	var to_target := target_pos - global_position

	if to_target.length() < 3.0:
		current_path.remove_at(0)
		if current_path.is_empty():
			velocity = Vector2.ZERO
			move_and_slide()
			return
		next_cell = current_path[0]
		target_pos = cell_to_world(next_cell)
		to_target = target_pos - global_position

	velocity = to_target.normalized() * move_speed
	move_and_slide()

func heuristic_manhattan(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)

func get_neighbors_4(cell: Vector2i) -> Array[Vector2i]:
	var dirs: Array[Vector2i] = [
		Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP
	]
	var result: Array[Vector2i] = []
	for d in dirs:
		var n := cell + d
		if is_walkable(n):
			result.append(n)
	return result

func find_path_astar(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	if not is_walkable(start) or not is_walkable(goal) or start == goal:
		return []

	var open_set: Array[Vector2i] = [start]
	var came_from: Dictionary = {}
	var g_score: Dictionary = {start: 0}
	var f_score: Dictionary = {start: heuristic_manhattan(start, goal)}

	while not open_set.is_empty():
		var current := open_set[0]
		var best_f: int = f_score.get(current, 999999999)
		for node in open_set:
			var f: int = f_score.get(node, 999999999)
			if f < best_f:
				best_f = f
				current = node

		if current == goal:
			return reconstruct_path(came_from, current)

		open_set.erase(current)

		for neighbor in get_neighbors_4(current):
			var tentative_g: int = g_score.get(current, 999999999) + 1
			if tentative_g < g_score.get(neighbor, 999999999):
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g
				f_score[neighbor] = tentative_g + heuristic_manhattan(neighbor, goal)
				if neighbor not in open_set:
					open_set.append(neighbor)

	return []

func find_path_dijkstra(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	if not is_walkable(start) or not is_walkable(goal) or start == goal:
		return []

	var unvisited: Array[Vector2i] = [start]
	var came_from: Dictionary = {}
	var cost_so_far: Dictionary = {start: 0}
	var visited: Dictionary = {}

	while not unvisited.is_empty():
		var current := unvisited[0]
		var best_cost: int = cost_so_far.get(current, 999999999)
		for node in unvisited:
			var c: int = cost_so_far.get(node, 999999999)
			if c < best_cost:
				best_cost = c
				current = node

		if current == goal:
			return reconstruct_path(came_from, current)

		unvisited.erase(current)
		visited[current] = true

		for neighbor in get_neighbors_4(current):
			if visited.has(neighbor):
				continue
			var new_cost: int = cost_so_far.get(current, 999999999) + 1
			if new_cost < cost_so_far.get(neighbor, 999999999):
				came_from[neighbor] = current
				cost_so_far[neighbor] = new_cost
				if neighbor not in unvisited:
					unvisited.append(neighbor)

	return []

func reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = [current]
	while came_from.has(current):
		current = came_from[current]
		if came_from.has(current):
			path.push_front(current)
	return path

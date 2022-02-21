extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(1, 0): E, Vector2(-1, 0): W,
				  Vector2(0, 1): S, Vector2(0, -1): N}

var tile_size = 64  # tile size (in pixels)
var width = 3  # width of map (in tiles)
var height = 3  # height of map (in tiles)
var erase_fraction = 0.4  # amount of attempted wall removals (can pick same one twice)
var unvisited = []  # array of unvisited tiles
var stack = []
var times_grown = 0
var times_completed = 0

var rand = RandomNumberGenerator.new()

var exits = [] #each entry corresponds to the exits at a lab size, in the order NESW

# get a reference to the map for convenience
onready var Map = $TileMap
onready var Goal1 = $Goal1
onready var Goal2 = $Goal2
onready var Goal3 = $Goal3
onready var Goal4 = $Goal4
onready var Player = $Player

signal maze_generated
signal walls_erased

func _ready():
	randomize()
	rand.randomize()
	tile_size = Map.cell_size
	make_maze()

func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func make_maze():
	# fill the map with solid tiles
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2(0, 0)
	unvisited.erase(current)

	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		#yield(get_tree(), 'idle_frame')
	exits.append([])
	
	var position = int(rand.randi_range(0, 2))
	exits[times_grown].append(Vector2(position, 0))
	Goal1.global_position = Vector2(200 + position * 400, 70)
	
	position = int(rand.randi_range(0, 2))
	exits[times_grown].append(Vector2(2, position))
	Goal2.global_position = Vector2(1200-70, 200 + position*400)
	
	position = int(rand.randi_range(0, 2))
	exits[times_grown].append(Vector2(position, 2))
	Goal3.global_position = Vector2(200 + position * 400, 1200-70)
	
	position = int(rand.randi_range(0, 2))
	exits[times_grown].append(Vector2(0,position))
	Goal4.global_position = Vector2(70, 200 + position * 400)
	
	emit_signal("maze_generated")

func erase_walls():
	 # randomly remove a percentage of the map's walls
	for i in range(int(width * height * erase_fraction)):
		var x
		var y
		if(times_grown == 0):
			# pick a random tile not on the edge
			x = int(rand_range(1, width-2))
			y = int(rand_range(1, height-2))
			var cell = Vector2(x, y)
			# pick a random neighbor
			var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
			# if there's a wall between cell and neighbor, remove it
			if Map.get_cellv(cell) & cell_walls[neighbor]:
				var walls = Map.get_cellv(cell) - cell_walls[neighbor]
				var n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
				Map.set_cellv(cell, walls)
				Map.set_cellv(cell+neighbor, n_walls)
			#yield(get_tree(), 'idle_frame')
		else:
			#pick a random tile not on the inner or outer edge on the newly generated parts
			if(randi() % 2 == 0):
				x = int(rand_range(1-3*times_grown, width+3*times_grown-2))
				if(randi() % 2 == 0):
					y = 1-3*times_grown
				else:
					y = height+3*times_grown-2
			else:
				y = int(rand_range(1-3*times_grown,height+3*times_grown-2))
				if(randi() % 2 == 0):
					x = 1-3*times_grown
				else:
					x = width+3*times_grown-2
			var cell = Vector2(x, y)
			# pick a random neighbor
			var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
			# if there's a wall between cell and neighbor, remove it
			if Map.get_cellv(cell) & cell_walls[neighbor]:
				var walls = Map.get_cellv(cell) - cell_walls[neighbor]
				var n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
				Map.set_cellv(cell, walls)
				Map.set_cellv(cell+neighbor, n_walls)
			#yield(get_tree(), 'idle_frame')
	times_grown += 1
	if(times_grown >= 2):
		create_openings()
	Player.respawn_at_random_position(times_grown-2)
	emit_signal("walls_erased")

func _on_Labyrinth_maze_generated():
	erase_walls()

func grow_maze():
	for x in range(-3 * (times_grown), width + 3 * (times_grown)):
		for y in range(-3 * (times_grown), height + 3 * (times_grown)):
			var previous = times_grown-1
			if( (x < -3 * previous) || (x >= width + 3 * previous) || (y < -3 * previous) || (y >= height + 3 * previous)):
				unvisited.append(Vector2(x, y))
				Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2(-3, -3)
	unvisited.erase(current)

	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		#yield(get_tree(), 'idle_frame')
		
	exits.append([])
	var growth = times_grown*3
	var position = int(rand.randi_range(0-growth, 2+growth))
	exits[-1].append(Vector2(position, 0-growth))
	Goal1.global_position = Vector2(200 + position * 400, 70-growth*400)
	
	position = int(rand.randi_range(0-growth, 2+growth))
	exits[-1].append(Vector2(2+growth, position))
	Goal2.global_position = Vector2(1200-70+growth*400, 200 + position*400)
	
	position = int(rand.randi_range(0-growth, 2+growth))
	exits[-1].append(Vector2(position, 2+growth))
	Goal3.global_position = Vector2(200 + position * 400, 1200-70+growth*400)
	
	position = int(rand.randi_range(0-growth, 2+growth))
	exits[-1].append(Vector2(0-growth,position))
	Goal4.global_position = Vector2(70-growth*400, 200 + position * 400)
	emit_signal("maze_generated")

#creates additional exits on the old maze
func create_openings():
	#north
	var cell = exits[-2][0]
	var neighbor = Vector2(0, -1)
	var walls = Map.get_cellv(cell) - cell_walls[neighbor]
	var n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
	Map.set_cellv(cell, walls)
	Map.set_cellv(cell+neighbor, n_walls)
	#east
	cell = exits[-2][1]
	neighbor = Vector2(1, 0)
	walls = Map.get_cellv(cell) - cell_walls[neighbor]
	n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
	Map.set_cellv(cell, walls)
	Map.set_cellv(cell+neighbor, n_walls)
	#south
	cell = exits[-2][2]
	neighbor = Vector2(0, 1)
	walls = Map.get_cellv(cell) - cell_walls[neighbor]
	n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
	Map.set_cellv(cell, walls)
	Map.set_cellv(cell+neighbor, n_walls)
	#west
	cell = exits[-2][3]
	neighbor = Vector2(-1, 0)
	walls = Map.get_cellv(cell) - cell_walls[neighbor]
	n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
	Map.set_cellv(cell, walls)
	Map.set_cellv(cell+neighbor, n_walls)
	

func _on_Player_goal_reached():
	times_completed += 1
	if(times_completed%3 == 0):
		grow_maze()
	else:
		Player.respawn_at_random_position(times_grown-2)

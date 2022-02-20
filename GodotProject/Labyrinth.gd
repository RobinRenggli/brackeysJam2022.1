extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(1, 0): E, Vector2(-1, 0): W,
				  Vector2(0, 1): S, Vector2(0, -1): N}

var tile_size = 64  # tile size (in pixels)
var width = 10  # width of map (in tiles)
var height = 6  # height of map (in tiles)
var erase_fraction = 0.4  # amount of attempted wall removals (can pick same one twice)
var unvisited = []  # array of unvisited tiles
var stack = []
var times_grown = 0

# get a reference to the map for convenience
onready var Map = $TileMap

signal maze_generated
signal walls_erased

func _ready():
	randomize()
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
	emit_signal("maze_generated")

func erase_walls():
	 # randomly remove a percentage of the map's walls
	for i in range(int(width * height * erase_fraction)):
		var x
		var y
		if(times_grown == 0):
			# pick a random tile not on the edge
			x = int(rand_range(1, width-1))
			y = int(rand_range(1, height-1))
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
	#if(times_grown > 1):
		#create_openings()
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
	emit_signal("maze_generated")

#creates additional exits on the old maze
func create_openings():
	pass

func _on_Player_goal_reached():
	grow_maze()

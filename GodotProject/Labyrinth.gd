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
var occluders = {}

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
			occluders[Vector2(x, y)] = []
			set_tile(Vector2(x, y), N|E|S|W)
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
			set_tile(current, current_walls)
			set_tile(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	exits.append([])
	
	respawn_all_goals()
	
	emit_signal("maze_generated")

func respawn_all_goals():
	spawn_goal('N')
	spawn_goal('E')
	spawn_goal('S')
	spawn_goal('W')

func set_tile(cell, walls):
	for i in occluders[cell]:
		if(is_instance_valid(i)):
			i.queue_free()
	Map.set_cellv(cell, walls)
	spawn_occluder(walls, cell)
		
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
				set_tile(cell, walls)
				set_tile(cell+neighbor, n_walls)
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
				set_tile(cell, walls)
				set_tile(cell+neighbor, n_walls)
	times_grown += 1
	if(times_grown >= 2):
		create_openings()
	Player.respawn_at_random_position(times_grown-2)
	emit_signal("walls_erased")

func _on_Labyrinth_maze_generated():
	erase_walls()

func grow_maze():
	AudioController.get_node("GrowLabSound").play()
	for x in range(-3 * (times_grown), width + 3 * (times_grown)):
		for y in range(-3 * (times_grown), height + 3 * (times_grown)):
			var previous = times_grown-1
			if( (x < -3 * previous) || (x >= width + 3 * previous) || (y < -3 * previous) || (y >= height + 3 * previous)):
				unvisited.append(Vector2(x, y))
				occluders[Vector2(x, y)] = []
				set_tile(Vector2(x, y), N|E|S|W)
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
			set_tile(current, current_walls)
			set_tile(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		
	exits.append([])
	respawn_all_goals()
	emit_signal("maze_generated")

#creates additional exits on the old maze
func create_openings():
	#north
	var cell = exits[-2][0]
	var neighbor = Vector2(0, -1)
	var walls = Map.get_cellv(cell) - cell_walls[neighbor]
	var n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
	set_tile(cell, walls)
	set_tile(cell+neighbor, n_walls)
	#east
	cell = exits[-2][1]
	neighbor = Vector2(1, 0)
	walls = Map.get_cellv(cell) - cell_walls[neighbor]
	n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
	set_tile(cell, walls)
	set_tile(cell+neighbor, n_walls)
	#south
	cell = exits[-2][2]
	neighbor = Vector2(0, 1)
	walls = Map.get_cellv(cell) - cell_walls[neighbor]
	n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
	set_tile(cell, walls)
	set_tile(cell+neighbor, n_walls)
	#west
	cell = exits[-2][3]
	neighbor = Vector2(-1, 0)
	walls = Map.get_cellv(cell) - cell_walls[neighbor]
	n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
	set_tile(cell, walls)
	set_tile(cell+neighbor, n_walls)
	
func _on_Player_goal_reached():
	times_completed += 1
	if(times_completed%3 == 0):
		grow_maze()
	else:
		Player.respawn_at_random_position(times_grown-2)
		
func spawn_goal(direction):
	var growth = times_grown*3
	var position
	if(direction == 'N'):
		position = int(rand.randi_range(0-growth, 2+growth))
		exits[-1].append(Vector2(position, 0-growth))
		Goal1.global_position = Vector2(200 + position*400, 70-growth*400)
	elif(direction == 'E'):
		position = int(rand.randi_range(0-growth, 2+growth))
		exits[-1].append(Vector2(2+growth, position))
		Goal2.global_position = Vector2(1200-70+growth*400, 200 + position*400)
	elif(direction == 'S'):
		position = int(rand.randi_range(0-growth, 2+growth))
		exits[-1].append(Vector2(position, 2+growth))
		Goal3.global_position = Vector2(200 + position * 400, 1200-70+growth*400)
	elif(direction == 'W'):
		position = int(rand.randi_range(0-growth, 2+growth))
		exits[-1].append(Vector2(0-growth,position))
		Goal4.global_position = Vector2(70-growth*400, 200 + position * 400)
		
func spawn_occluder(walls, position):
	var upper_left_corner = OccluderPolygon2D.new()
	upper_left_corner.set_polygon([Vector2(0,0), Vector2(40,0), Vector2(40,25), Vector2(0,25)])
	var upper_right_corner = OccluderPolygon2D.new()
	upper_right_corner.set_polygon([Vector2(360,0), Vector2(400,0), Vector2(400,25), Vector2(360,25)])
	var lower_left_corner = OccluderPolygon2D.new()
	lower_left_corner.set_polygon([Vector2(0,400), Vector2(50,400), Vector2(50,330), Vector2(0,330)])
	var lower_right_corner = OccluderPolygon2D.new()
	lower_right_corner.set_polygon([Vector2(350,400), Vector2(400,400), Vector2(400,330), Vector2(350,330)])

	var upper_wall = OccluderPolygon2D.new()
	upper_wall.set_polygon([Vector2(0,0), Vector2(400,0), Vector2(400,25), Vector2(0,25)])
	
	var lower_wall = OccluderPolygon2D.new()
	lower_wall.set_polygon([Vector2(0,400),Vector2(400,400),Vector2(400,330),Vector2(0,330)])
	
	var left_wall = OccluderPolygon2D.new()
	left_wall.set_polygon([Vector2(0,0),Vector2(50,0),Vector2(50,400),Vector2(0,400)])
	
	var right_wall = OccluderPolygon2D.new()
	right_wall.set_polygon([Vector2(350,0), Vector2(400,0), Vector2(400,400), Vector2(350,400)])
	
	var occluder_north = LightOccluder2D.new()
	occluder_north.set_occluder_polygon(upper_wall)
	var occluder_east = LightOccluder2D.new()
	occluder_east.set_occluder_polygon(right_wall)
	var occluder_south = LightOccluder2D.new()
	occluder_south.set_occluder_polygon(lower_wall)
	var occluder_west = LightOccluder2D.new()
	occluder_west.set_occluder_polygon(left_wall)
	
	var occluder_northeast = LightOccluder2D.new()
	occluder_northeast.set_occluder_polygon(upper_right_corner)
	var occluder_southeast = LightOccluder2D.new()
	occluder_southeast.set_occluder_polygon(lower_right_corner)
	var occluder_southwest = LightOccluder2D.new()
	occluder_southwest.set_occluder_polygon(lower_left_corner)
	var occluder_northwest = LightOccluder2D.new()
	occluder_northwest.set_occluder_polygon(upper_left_corner)
	
	position.x *= 400
	position.y *= 400
	
	occluder_north.global_position = Vector2(position.x, position.y)
	occluder_east.global_position = Vector2(position.x, position.y)
	occluder_south.global_position = Vector2(position.x, position.y)
	occluder_west.global_position = Vector2(position.x, position.y)
	occluder_northeast.global_position = Vector2(position.x, position.y)
	occluder_southeast.global_position = Vector2(position.x, position.y)
	occluder_southwest.global_position = Vector2(position.x, position.y)
	occluder_northwest.global_position = Vector2(position.x, position.y)
	
	if(walls == 0):
		add_occluder(occluder_northeast, position)
		add_occluder(occluder_southeast, position)
		add_occluder(occluder_northwest, position)
		add_occluder(occluder_southwest, position)
	elif(walls == 1):
		add_occluder(occluder_north, position)
		add_occluder(occluder_southwest, position)
		add_occluder(occluder_southeast, position)
	elif(walls == 2):
		add_occluder(occluder_east, position)
		add_occluder(occluder_northwest, position)
		add_occluder(occluder_southwest, position)
	elif(walls == 3):
		add_occluder(occluder_north, position)
		add_occluder(occluder_east, position)
		add_occluder(occluder_southwest, position)
	elif(walls == 4):
		add_occluder(occluder_northeast, position)
		add_occluder(occluder_northwest, position)
		add_occluder(occluder_south, position)
	elif(walls == 5):
		add_occluder(occluder_north, position)
		add_occluder(occluder_south, position)
	elif(walls == 6):
		add_occluder(occluder_south, position)
		add_occluder(occluder_east, position)
		add_occluder(occluder_northwest, position)
	elif(walls == 7):
		add_occluder(occluder_north, position)
		add_occluder(occluder_east, position)
		add_occluder(occluder_south, position)
	elif(walls == 8):
		add_occluder(occluder_west, position)
		add_occluder(occluder_northeast, position)
		add_occluder(occluder_southeast, position)
	elif(walls == 9):
		add_occluder(occluder_north, position)
		add_occluder(occluder_west, position)
		add_occluder(occluder_southeast, position)
	elif(walls == 10):
		add_occluder(occluder_east, position)
		add_occluder(occluder_west, position)
	elif(walls == 11):
		add_occluder(occluder_north, position)
		add_occluder(occluder_east, position)
		add_occluder(occluder_west, position)
	elif(walls == 12):
		add_occluder(occluder_west, position)
		add_occluder(occluder_south, position)
		add_occluder(occluder_northeast, position)
	elif(walls == 13):
		add_occluder(occluder_north, position)
		add_occluder(occluder_west, position)
		add_occluder(occluder_south, position)
	elif(walls == 14):
		add_occluder(occluder_east, position)
		add_occluder(occluder_west, position)
		add_occluder(occluder_south, position)
	elif(walls == 15):
		pass

func add_occluder(occluder, position):
	position.x /= 400
	position.y /= 400
	add_child(occluder)
	occluders[position].append(occluder)

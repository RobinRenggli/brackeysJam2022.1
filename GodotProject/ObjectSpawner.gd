extends Node

var permanent_objects = [
	{
		"resource": preload("res://Labyrinth/Candelabra.tscn"),
		"spawn_chance": 9,
		"position_offset": Vector2(200, 150),
		"possible_tiles": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
		"spawn_at_start": true
	},
	{
		"resource": preload("res://CollectableObjects/SanityFruit.tscn"),
		"spawn_chance": 30,
		"position_offset": Vector2(200, 200),
		"possible_tiles": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
		"spawn_at_start": false
	},
	{
		"resource": preload("res://CollectableObjects/SpeedFruit.tscn"),
		"spawn_chance": 60,
		"position_offset": Vector2(200, 200),
		"possible_tiles": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
		"spawn_at_start": false
	},
	{
		"resource": preload("res://Labyrinth/painting.tscn"),
		"spawn_chance": 5,
		"position_offset": Vector2(0, 0),
		"possible_tiles": [1, 3, 5, 7, 9, 11, 13],
		"spawn_at_start": true
	},
	{
		"resource": preload("res://Labyrinth/Couch/Couch.tscn"),
		"spawn_chance": 10,
		"position_offset": Vector2(190, 80),
		"possible_tiles": [1, 3, 5, 7, 9, 11, 13],
		"spawn_at_start": false
	},
	{
		"resource": preload("res://Enemies/GuardEnemy.tscn"),
		"spawn_chance": 40,
		"position_offset": Vector2(190, 80),
		"possible_tiles": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
		"spawn_at_start": false
	},
	{
		"resource": preload("res://CollectableObjects/Dog/Dog.tscn"),
		"spawn_chance": 100,
		"position_offset": Vector2(200, 200),
		"possible_tiles": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
		"spawn_at_start": false
	},
]
var Labyrinth

func _ready():
	Labyrinth = get_parent()
	Labyrinth.connect("maze_generated", self, "spawn_on_new_tiles")

func spawn_on_new_tiles():
	var times_grown = Labyrinth.times_grown - 1
	var width = Labyrinth.width
	var height = Labyrinth.height
	for x in range(-3 * (times_grown), width + 3 * (times_grown)):
		for y in range(-3 * (times_grown), height + 3 * (times_grown)):
			var previous = times_grown - 1
			if times_grown == 0 or ((x < -3 * previous) || (x >= width + 3 * previous) || (y < -3 * previous) || (y >= height + 3 * previous)):
				spawn_on_tile(permanent_objects, x, y)

func spawn_on_tile(objects, x, y):
	for entry in Labyrinth.exits:
		for exit in entry:
			if exit.x == x and exit.y == y:
				return
	var cellv = Labyrinth.Map.get_cellv(Vector2(x, y))
	var Rand = RandomNumberGenerator.new()
	Rand.randomize()
	for obj in objects:
		if (not obj["spawn_at_start"]) and x >= 0 and x < 3 and y >= 0 and y < 3:
			continue 
		if Rand.randi_range(1, obj["spawn_chance"]) == 1 and cellv in obj["possible_tiles"]:
			var instance = obj["resource"].instance()
			instance.global_position = Vector2(x * 400, y * 400) + obj["position_offset"]
			Labyrinth.add_child(instance)



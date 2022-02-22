extends Node2D

export var couches = [
	preload("res://Labyrinth/Couch/CouchBlue.png"),
	preload("res://Labyrinth/Couch/CouchGreen.png"),
	preload("res://Labyrinth/Couch/CouchPurple.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var Rand = RandomNumberGenerator.new()
	Rand.randomize()
	$Sprite.texture = couches[Rand.randi_range(0, couches.size() - 1)]

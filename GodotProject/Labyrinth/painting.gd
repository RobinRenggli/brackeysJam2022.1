extends Node2D

export var paintings = [
	preload("res://Labyrinth/Paintings/20thCentury.png"),
	preload("res://Labyrinth/Paintings/David.png"),
	preload("res://Labyrinth/Paintings/Marsyas.png"),
	preload("res://Labyrinth/Paintings/Pope.png"),
	preload("res://Labyrinth/Paintings/Scream.png"),
	preload("res://Labyrinth/Paintings/WeepingWoman.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var Rand = RandomNumberGenerator.new()
	Rand.randomize()
	$Sprite.texture = paintings[Rand.randi_range(0, paintings.size() - 1)]


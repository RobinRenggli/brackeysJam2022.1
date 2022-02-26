extends Node2D

func _ready():
	offset_position()

func offset_position():
	randomize()
	global_position += Vector2(rand_range(-80, 80), rand_range(-80, 80))

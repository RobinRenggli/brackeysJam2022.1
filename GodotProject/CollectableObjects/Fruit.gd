extends Node2D

func _on_Area2D_area_entered(area):
	area.get_parent().on_fruit_pickup()
	queue_free()
	AudioController.get_node("EatFruitSound").play()

func _ready():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	global_position = Vector2(200 + rand.randi_range(0, 5) * 400, 200 + rand.randi_range(0, 5) * 400)

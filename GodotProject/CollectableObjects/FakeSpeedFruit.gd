extends Node2D

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		area.get_parent().on_fake_speed_fruit_pickup()
		queue_free()
	if area.get_parent().is_in_group("Enemies"):
		queue_free()

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")

func _on_goal_reached():
	queue_free()

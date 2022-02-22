extends Node2D

func _on_Area2D_area_entered(area):
	if not area.get_parent().is_in_group("Enemies"):
		area.get_parent().on_speed_fruit_pickup()
	visible = false
	$Area2D.monitorable = false
	$Area2D.monitoring = false

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")

func _on_goal_reached():
	visible = true
	$Area2D.monitorable = true
	$Area2D.monitoring = true

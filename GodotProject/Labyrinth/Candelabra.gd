extends Node2D

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")

func _on_Area2D_area_entered(area):
	$Light2D.enabled = true

func _on_goal_reached():
	$Light2D.enabled = false

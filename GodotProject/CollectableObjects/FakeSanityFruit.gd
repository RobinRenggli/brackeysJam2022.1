extends Node2D

func _on_Area2D_area_entered(area):
	if (area.is_in_group("Detector")):
		$CPUParticles2D2.modulate.a = 0.9
		$CPUParticles2D.modulate.a = 0
	elif area.get_parent().is_in_group("Player"):
		area.get_parent().on_fake_sanity_fruit_pickup()
		queue_free()

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")

func _on_goal_reached():
	queue_free()


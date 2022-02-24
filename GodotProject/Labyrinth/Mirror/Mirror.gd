extends Node2D

var activated = false
var follower = preload("res://Enemies/FollowerEnemy.tscn")

func _on_Area2D_area_entered(area):
	if (!activated):
		activated = true
		yield(get_tree().create_timer(5), "timeout")
		var instance = follower.instance()
		instance.global_position = self.global_position + Vector2(200,50)
		$"../../Labyrinth".add_child(instance)

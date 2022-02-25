extends Node2D

var activated = false
var follower = preload("res://Enemies/FollowerEnemy.tscn")

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	
func _on_goal_reached():
	activated = false

func _on_Area2D_area_entered(area):
	if (!activated && !get_tree().has_group("follower")):
		activated = true
		yield(get_tree().create_timer(3), "timeout")
		var instance = follower.instance()
		instance.global_position = self.global_position + Vector2(200,50)
		$"../../Labyrinth".add_child(instance)
		AudioController.get_node("FollowerEnemySound").play()

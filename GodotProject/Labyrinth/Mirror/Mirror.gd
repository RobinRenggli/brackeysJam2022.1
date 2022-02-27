extends Node2D

var activated = false
var follower = preload("res://Enemies/FollowerEnemy.tscn")

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	
func _on_goal_reached():
	activated = false

func _on_Area2D_area_entered(area):
	if (!activated && !get_tree().has_group("Follower")):
		$Timer.start()
		activated = true
		yield(get_tree().create_timer(2), "timeout")
		var instance = follower.instance()
		instance.global_position = self.global_position + Vector2(200,50)
		$"../../Labyrinth".add_child(instance)
		$FollowerEnemySound.play()
	elif(!activated):
		$Timer.start()
		activated = true
		yield(get_tree().create_timer(0.5), "timeout")
		$"../../Labyrinth/FollowerEnemy".global_position = self.global_position + Vector2(200,50)
		$FollowerEnemySound.play()


func _on_Timer_timeout():
	activated = false

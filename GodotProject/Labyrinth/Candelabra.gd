extends Node2D

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")

func _on_Area2D_area_entered(area):
	$Light2D.enabled = true
	play_candle_on_animation()

func _on_goal_reached():
	$Light2D.enabled = false
	play_candle_off_animation()

func play_candle_on_animation():
	$AnimationPlayer.play("candle_on")

func play_candle_off_animation():
	$AnimationPlayer.play("candle_off")

extends Node2D

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	offset_position()

func _on_Area2D_area_entered(area):
	if !$Light2D.enabled:
		if area.get_parent().is_in_group("Player"):
			AudioController.get_node("CandelabraSound").play()
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().get_node("EnemyCandelabraSound").play()
		play_candle_on_animation()
	$Light2D.enabled = true

func _on_goal_reached():
	$Light2D.enabled = false
	play_candle_off_animation()

func play_candle_on_animation():
	$AnimationPlayer.play("candle_on")

func play_candle_off_animation():
	$AnimationPlayer.play("candle_off")

func offset_position():
	randomize()
	global_position += Vector2(rand_range(-60, 60), rand_range(-60, 60))

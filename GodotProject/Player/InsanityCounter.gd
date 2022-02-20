extends Node2D

export var insanity = 10


func _ready():
	$InsanityText.text = str(insanity)

func reset():
	insanity = 10
	$InsanityText.text = str(insanity)
	$Timer.wait_time = 30

func _on_Timer_timeout():
	insanity -= 1
	$InsanityText.text = str(insanity)
	if insanity <= 0:
		EnemyStorage.stored_enemies = []
		get_tree().reload_current_scene()

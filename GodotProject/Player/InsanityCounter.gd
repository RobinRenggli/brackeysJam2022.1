extends Node2D

export var insanity = 12


func _ready():
	$InsanityText.text = str(insanity)

func reset():
	insanity = 12
	$InsanityText.text = str(insanity)
	$Timer.wait_time = 30
	heartbeat()

func _on_Timer_timeout():
	insanity -= 1
	$InsanityText.text = str(insanity)
	heartbeat()
	if insanity <= 0:
		EnemyStorage.stored_enemies = []
		get_tree().reload_current_scene()

func increase(amount):
	insanity += amount
	$InsanityText.text = str(insanity)
	heartbeat()

func heartbeat():
	print(insanity)
	yield(AudioController.get_node("Sync"), "synced")
	if insanity <= 2:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").play()
	elif insanity <= 4:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").play()
		AudioController.get_node("Heartbeat6").stop()
	elif insanity <= 6:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").play()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()
	elif insanity <= 8:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").play()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()
	elif insanity <= 10:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").play()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()
	else:
		AudioController.get_node("Heartbeat1").play()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()

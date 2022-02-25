extends Control


export var sanity = 6 setget set_sanity, get_sanity
export var sanity_decrease_interval = 20
var max_sanity = 6 setget set_max_sanity
var sanity_counter_size = 65
var sanity_old = 6

onready var sanityUIEmpty = $SanityUIEmpty
onready var sanityUIFull = $SanityUIFull
onready var sanityUIHalf = $SanityUIHalf

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	$Timer.set_wait_time(sanity_decrease_interval)

func set_sanity(value):
	sanity = clamp(value, 0, max_sanity)
	if sanityUIFull != null:
		sanityUIFull.rect_size.x = sanity * sanity_counter_size
	heartbeat()
	if sanity == 0.5:
		sanityUIHalf.visible = true
	if sanity == 0:
		EnemyStorage.stored_enemies = []
		sanityUIFull.visible = false
		sanityUIHalf.visible = false
		#yield(get_tree().create_timer(1), "timeout")
		AudioController.get_node("DeathSound").play()
		heartbeat()
		TransitionScreen.transition()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://Scenes/GameOverScene.tscn")

func get_sanity():
	return sanity

func set_max_sanity(value):
	max_sanity = max(value, 1)
	if sanityUIFull != null:
		sanityUIFull.rect_size.x = max_sanity * sanity_counter_size

func reset():
	set_sanity(max_sanity)
	$Timer.wait_time = 30
	heartbeat()

func _on_Timer_timeout():
	set_sanity(sanity - 0.5)
	heartbeat()

func _on_goal_reached():
	$Timer.set_wait_time(sanity_decrease_interval)

func heartbeat():
	if sanity > 0:
		yield(AudioController.get_node("Sync"), "timeout")
	#print(sanity)
	if sanity <= 0:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()
	elif sanity <= 1:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").play()
	elif sanity <= 2:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").play()
		AudioController.get_node("Heartbeat6").stop()
	elif sanity <= 3:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").play()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()
	elif sanity <= 4:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").play()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()
	elif sanity <= 5:
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

func _process(_delta):
	if sanity < sanity_old:
		AudioController.get_node("DamageSound").play()
	sanity_old = sanity

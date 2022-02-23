extends Timer

signal synced
var fired = false
#var cnt = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if get_time_left() <= 1.936 and not fired:
		emit_signal("synced")
		fired = true

func _on_Sync_timeout():
	fired = false


func _on_Heartbeat1_finished():
	emit_signal("synced")

func _on_Heartbeat2_finished():
	emit_signal("synced")


func _on_Heartbeat3_finished():
	emit_signal("synced")


func _on_Heartbeat4_finished():
	emit_signal("synced")


func _on_Heartbeat5_finished():
	emit_signal("synced")


func _on_Heartbeat6_finished():
	emit_signal("synced")

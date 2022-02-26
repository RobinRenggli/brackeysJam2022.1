extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Continue_pressed():
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	AudioController.get_node("ClickSound").play()

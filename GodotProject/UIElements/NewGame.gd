extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_NewGame_pressed():
	AudioController.get_node("ClickSound").play()
	AudioController.get_node("StartGameSound").play()
	TransitionScreen.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Labyrinth.tscn")

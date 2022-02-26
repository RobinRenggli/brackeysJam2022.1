extends CanvasLayer

onready var number_escapes_ui = $MainContainer/MarginContainer/VSplitContainer/VBoxContainer/HBoxContainer/NumberEscapes
onready var escape_text_2 = $MainContainer/MarginContainer/VSplitContainer/VBoxContainer/HBoxContainer/EscapeText2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	number_escapes_ui.text = str(Overviewer.times_completed)
	if Overviewer.times_completed == 1:
		escape_text_2.text = " time..."
	else:
		escape_text_2.text = " times..."

func _on_Continue_pressed():
	TransitionScreen.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	AudioController.get_node("ClickSound").play()

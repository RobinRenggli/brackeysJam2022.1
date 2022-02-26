extends CanvasLayer

onready var number_escapes_ui = $MainContainer/MarginContainer/VSplitContainer/VBoxContainer/HBoxContainer/NumberEscapes

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	number_escapes_ui.text = str(Overviewer.times_completed)

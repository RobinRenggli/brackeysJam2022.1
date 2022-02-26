extends Node

onready var text_speed_option = $MainContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/TextSpeed

func _ready():
	add_text_speed_options()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func add_text_speed_options():
	text_speed_option.add_item(" Text Speed: Slow")
	text_speed_option.add_item(" Text Speed: Medium")
	text_speed_option.add_item(" Text Speed: Fast")
	text_speed_option.select(Overviewer.text_speed)

func _on_TextSpeed_item_selected(index):
	Overviewer.text_speed = index

func _on_ShowText_toggled(button_pressed):
	Overviewer.display_text = button_pressed
	if button_pressed:
		text_speed_option.disabled = false
	else:
		text_speed_option.disabled = true

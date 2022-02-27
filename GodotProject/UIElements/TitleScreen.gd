extends Node

onready var text_speed_option = $MainContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/TextSpeed
onready var show_text_option = $MainContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/ShowText

func _ready():
	set_text_speed_options()
	set_show_text_option()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func set_show_text_option():
	show_text_option.pressed = Overviewer.display_text

func set_text_speed_options():
	text_speed_option.add_item(" Text Speed: Slow")
	text_speed_option.add_item(" Text Speed: Medium")
	text_speed_option.add_item(" Text Speed: Fast")
	text_speed_option.select(Overviewer.text_speed)

func _on_TextSpeed_item_selected(index):
	AudioController.get_node("ClickSound").play()
	Overviewer.text_speed = index

func _on_ShowText_toggled(button_pressed):
	Overviewer.display_text = button_pressed
	AudioController.get_node("ClickSound").play()
	if button_pressed:
		text_speed_option.disabled = false
	else:
		text_speed_option.disabled = true

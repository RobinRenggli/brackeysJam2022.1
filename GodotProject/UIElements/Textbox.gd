extends CanvasLayer

const CHAR_READ_RATE = 0.12

onready var textbox_container = $TextBoxContainer
onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/StartSymbol
onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/EndSymbol
onready var label_text = $TextBoxContainer/MarginContainer/HBoxContainer/LabelText

var current_state = State.READY
var text_queue = []

enum State {
	READY,
	READING
}

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox()

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			pass

func change_state(next_state):
	current_state = next_state

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label_text.text = ""
	textbox_container.hide()

func display_text():
	get_tree().paused = true
	var read_time = 0
	var next_text = ""
	
	change_state(State.READING)
	
	next_text = text_queue.pop_front()
	read_time = len(next_text) * CHAR_READ_RATE
	label_text.text = next_text
	label_text.percent_visible = 0.0
	textbox_container.show()
	
	# fade in text
	$Tween.interpolate_property(label_text, "percent_visible", 0.0, 1.0, read_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(read_time + 1), "timeout")
	$Tween.remove_all()
	
	# fade out text
	$Tween.interpolate_property(label_text, "modulate:a", 1.0, 0.0, 1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(textbox_container, "modulate:a", 1.0, 0.0, 1.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(1.5), "timeout")
	
	# clean up
	label_text.modulate.a = 1.0
	textbox_container.modulate.a = 1.0
	$Tween.remove_all()
	hide_textbox()
	change_state(State.READY)
	get_tree().paused = false

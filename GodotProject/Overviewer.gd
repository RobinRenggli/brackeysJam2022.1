extends Node

signal goal_reached

var times_completed = 0

var display_text = true
var text_speed = 1

var intro_dialog = true
var first_exit_dialog = true
var first_grow_dialog = true
var first_enemy_dialog = true
var first_guard_dialog = true
var dog_dialog = true
var teddy_dialog = true
var apple_dialog = true
var orange_dialog = true
var fake_fruit_dialog = true
var follower_dialog = true
var ready_dialog = true

var dog = false
var teddy = false
var escaped = true

func _ready():
	pass # Replace with function body.
	
func reset():
	dog = false
	teddy = false
	escaped = true


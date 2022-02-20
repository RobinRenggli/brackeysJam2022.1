extends Node

var player
var position_history = []
var playback = false
var playback_index = 0

func _ready():
	player = get_parent()

func _physics_process(delta):
	record_position(player)

func record_position(player):
	position_history.append({
		"position": player.global_position,
		"direction": player.velocity,
		})

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		store()

func store():
	EnemyStorage.store_enemy(position_history)

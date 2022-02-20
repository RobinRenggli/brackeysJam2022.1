extends Node

var player
var position_history = []
var playback = false
var playback_index = 0
var recording = true

func _ready():
	player = get_parent()

func _physics_process(delta):
	if recording:
		record_position(player)

func record_position(player):
	position_history.append({
		"position": player.global_position,
		"direction": player.velocity,
		})

func store():
	recording = false
	EnemyStorage.store_enemy(position_history.duplicate(true))
	position_history = []

func start_recording():
	recording = true

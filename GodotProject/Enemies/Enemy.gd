extends KinematicBody2D

var position_history
var playback_index
var moving = false

export (int) var speed = 200
export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;

func start_moving():
	print("started")
	playback_index = 0
	moving = true

func _physics_process(delta):
	if moving:
		var index = min(playback_index, position_history.size() - 1)
		var history_entry = position_history[index]
		print(history_entry)
		playback_index += 1
		global_position = history_entry["position"]
		var direction = history_entry["direction"]
		if direction.x > 0:
			$Sprite.texture = face_right
		elif direction.x < 0:
			$Sprite.texture = face_left
		elif direction.y > 0:
			$Sprite.texture = face_down
		elif direction.y < 0:
			$Sprite.texture = face_up

func _on_Hitbox_body_entered(body):
	EnemyStorage.stored_enemies = []
	get_tree().reload_current_scene()

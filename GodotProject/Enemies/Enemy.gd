extends KinematicBody2D

var position_history
var playback_index
var moving = false
var move_backwards = false

export (int) var speed = 200
export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;

func _ready():
	play_spawn_animation()
	$Sprite.visible = false
	global_position = position_history[0]["position"]
	yield(get_tree().create_timer(5, false), "timeout")
	start_moving()

func start_moving():
	$Sprite.visible = true
	playback_index = 0
	moving = true
	play_moving_animation()
	$EnemyHitbox.monitorable = true
	$EnemyHitbox.monitoring = true
	$EnemySpawnSound.play()

func _physics_process(delta):
	if moving:
		var index = min(playback_index, position_history.size() - 1)
		var history_entry = position_history[index]
		global_position = history_entry["position"]
		var direction = history_entry["direction"]
		if not move_backwards:
			if direction.x > 0:
				$Sprite.texture = face_right
			elif direction.x < 0:
				$Sprite.texture = face_left
			elif direction.y > 0:
				$Sprite.texture = face_down
			elif direction.y < 0:
				$Sprite.texture = face_up
			if playback_index >= position_history.size() - 1:
				playback_index -= 1
				move_backwards = true
			else:
				playback_index += 1
		else:
			if direction.x > 0:
				$Sprite.texture = face_left
			elif direction.x < 0:
				$Sprite.texture = face_right
			elif direction.y > 0:
				$Sprite.texture = face_up
			elif direction.y < 0:
				$Sprite.texture = face_down
			if playback_index <= 0:
				playback_index += 1
				move_backwards = false
			else:
				playback_index -= 1
				
func play_spawn_animation():
	$AnimationPlayer.play("enemy_spawn_start")

func play_moving_animation():
	$AnimationPlayer.play("enemy_spawn_end")
	

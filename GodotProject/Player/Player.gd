extends KinematicBody2D

export (int) var speed = 400
export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;

var velocity = Vector2()

signal goal_reached

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
		$Sprite.texture = face_right
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 1
		$Sprite.texture = face_left
	elif Input.is_action_pressed('move_down'):
		velocity.y += 1
		$Sprite.texture = face_down
	elif Input.is_action_pressed('move_up'):
		velocity.y -= 1
		$Sprite.texture = face_up
	elif Input.is_action_pressed("zoom_out"):
		$Camera2D.zoom += Vector2(0.25, 0.25)
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func on_goal_reached():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.queue_free()
	$InsanityCounter.reset()
	$PositionRecorder.store()
	emit_signal("goal_reached")
	EnemyStorage.spawn_enemies()

func respawn_at_random_position(times_grown):
	if(times_grown < 0):
		times_grown = 0
	var growth = times_grown*3
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	global_position = Vector2(200 + rand.randi_range(0, 2) * 400, 200 + rand.randi_range(0, 2) * 400)
	$PositionRecorder.start_recording()
	
func on_fruit_pickup():
	$InsanityCounter.increase(1)

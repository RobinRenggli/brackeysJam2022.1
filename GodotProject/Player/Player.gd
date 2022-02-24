extends KinematicBody2D

export (int) var start_speed = 400
export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;

var velocity = Vector2()
var speed = start_speed

onready var sanity_counter_ui = $"../UILayer/SanityCounterUI"

signal goal_reached

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
		$Sprite.texture = face_right
		$MirrorSprite.texture = face_right
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 1
		$Sprite.texture = face_left
		$MirrorSprite.texture = face_left
	elif Input.is_action_pressed('move_down'):
		velocity.y += 1
		$Sprite.texture = face_down
		$MirrorSprite.texture = face_up
	elif Input.is_action_pressed('move_up'):
		velocity.y -= 1
		$Sprite.texture = face_up
		$MirrorSprite.texture = face_down
	elif Input.is_action_pressed("zoom_out"):
		$Camera2D.zoom += Vector2(0.25, 0.25)
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func on_goal_reached():
	speed = start_speed
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.queue_free()
	sanity_counter_ui.reset()
	$PositionRecorder.store()
	emit_signal("goal_reached")
	Overviewer.emit_signal("goal_reached")
	EnemyStorage.spawn_enemies()

func respawn_at_random_position(times_grown):
	if(times_grown < 0):
		times_grown = 0
	var growth = times_grown*3
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	global_position = Vector2(200 + rand.randi_range(0, 2) * 400, 200 + rand.randi_range(0, 2) * 400)
	$PositionRecorder.start_recording()
	sanity_counter_ui.heartbeat()
	
func on_sanity_fruit_pickup():
	sanity_counter_ui.set_sanity(sanity_counter_ui.get_sanity() + 1)
	AudioController.get_node("SanityFruitSound").play()

func on_fake_sanity_fruit_pickup():
	sanity_counter_ui.set_sanity(sanity_counter_ui.get_sanity() - 1)
	AudioController.get_node("FakeFruitSound").play()

func on_speed_fruit_pickup():
	speed += 50
	AudioController.get_node("SpeedFruitSound").play()
	
func on_fake_speed_fruit_pickup():
	speed = max(speed - 50, 50)
	AudioController.get_node("FakeFruitSound").play()

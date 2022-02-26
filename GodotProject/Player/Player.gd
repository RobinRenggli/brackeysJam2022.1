extends KinematicBody2D

export (int) var start_speed = 400
export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;

var velocity = Vector2()
var speed = start_speed

onready var sanity_counter_ui = $"../UILayer/SanityCounterUI"
onready var TextBox = $"../UILayer/TextBox"

signal goal_reached

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
		$Sprite.texture = face_right
		$MirrorSprite.texture = face_right
		$Teddy.z_index = 1
		$Teddy.rotation_degrees = 35
		$Teddy.position = Vector2(10, 28)
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 1
		$Sprite.texture = face_left
		$MirrorSprite.texture = face_left
		$Teddy.z_index = -1
		$Teddy.rotation_degrees = -35
		$Teddy.position = Vector2(-6, 28)
	elif Input.is_action_pressed('move_down'):
		velocity.y += 1
		$Sprite.texture = face_down
		$MirrorSprite.texture = face_up
		$Teddy.z_index = 0
		$Teddy.rotation_degrees = -35
		$Teddy.position = Vector2(-6, 28)
	elif Input.is_action_pressed('move_up'):
		velocity.y -= 1
		$Sprite.texture = face_up
		$MirrorSprite.texture = face_down
		$Teddy.z_index = -1
		$Teddy.rotation_degrees = 35
		$Teddy.position = Vector2(10, 28)
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

func respawn_at_random_position(times_grown):
	if(times_grown < 0):
		times_grown = 0
	var growth = times_grown*3
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	global_position = Vector2(200 + rand.randi_range(1, 1) * 400, 200 + rand.randi_range(1, 1) * 400)
	$PositionRecorder.start_recording()
	sanity_counter_ui.heartbeat()
	
func on_sanity_fruit_pickup():
	if(Overviewer.apple_dialog && Overviewer.display_text):
		Overviewer.apple_dialog = false
		TextBox.queue_text("An apple a day, keeps the doctor away.")
	sanity_counter_ui.set_sanity(sanity_counter_ui.get_sanity() + 1)
	AudioController.get_node("SanityFruitSound").play()

func on_fake_sanity_fruit_pickup():
	if(Overviewer.fake_fruit_dialog && Overviewer.display_text):
		Overviewer.fake_fruit_dialog = false
		TextBox.queue_text("Ouch! This isn't real fruit!")
	sanity_counter_ui.set_sanity(sanity_counter_ui.get_sanity() - 1)
	AudioController.get_node("FakeFruitSound").play()

func on_speed_fruit_pickup():
	if(Overviewer.orange_dialog && Overviewer.display_text):
		Overviewer.orange_dialog = false
		TextBox.queue_text("A red apple. Sweet and energizing!")
	speed += 50
	AudioController.get_node("SpeedFruitSound").play()
	
func on_fake_speed_fruit_pickup():
	if(Overviewer.fake_fruit_dialog && Overviewer.display_text):
		Overviewer.fake_fruit_dialog = false
		TextBox.queue_text("Ouch! This is hard as stone.")
	speed = max(speed - 50, 50)
	AudioController.get_node("FakeFruitSound").play()

func _on_Detector_area_entered(area):
	if(area.is_in_group("Follower") && Overviewer.teddy && Overviewer.dog && Overviewer.escaped):
		Overviewer.escaped = false
		Overviewer.display_text = true
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()
		AudioController.get_node("VictorySound").play()
		AudioController.get_node("MainLoop").stop()
		TextBox.queue_text("I'm not scared of you anymore!")
		TextBox.queue_text("You're just... me.")
		var me = area.get_parent()
		me.evil = false
		yield(get_tree().create_timer(5), "timeout")		
		me.get_node("AnimationPlayer").play("transform")
		victory_scene(me)
	elif(Overviewer.display_text):
		if(area.is_in_group("BasicEnemy") && Overviewer.first_enemy_dialog):
			Overviewer.first_enemy_dialog = false
			TextBox.queue_text("Who is that?")
			TextBox.queue_text("Stay away from me!")
		elif(area.is_in_group("GuardEnemy") && Overviewer.first_guard_dialog):
			Overviewer.first_guard_dialog = false
			TextBox.queue_text("Who's there?")
			TextBox.queue_pause_seconds(1.5)
			TextBox.queue_text("Oh god, it's following me!")
		elif(area.is_in_group("Friend") && Overviewer.dog_dialog):
			Overviewer.dog_dialog = false
			TextBox.queue_text("I remember you... You're my friend!")
			if(Overviewer.teddy):
				Overviewer.ready_dialog = false
				TextBox.queue_text("Together with you, I feel ready to face myself.")
		elif(area.is_in_group("Cuddly") && Overviewer.teddy_dialog):
			Overviewer.teddy_dialog = false
			TextBox.queue_text("My teddy! It always gave me comfort.")
			if(Overviewer.dog):
				Overviewer.ready_dialog = false
				TextBox.queue_text("Together with you, I feel ready to face myself.")
		elif(area.is_in_group("Follower") && Overviewer.follower_dialog):
			Overviewer.follower_dialog = false
			TextBox.queue_text("Oh no, something came out of the mirror!")
			TextBox.queue_pause_seconds(2)
			TextBox.queue_text("Leave me alone! I hate you!")
			
func victory_scene(me):
	$Sprite.texture = face_down
	TextBox.queue_text("I accept you.")
	yield(get_tree().create_timer(3), "timeout")
	var tween = $Tween
	var middle = (self.global_position + me.global_position)/2
	tween.interpolate_property(me, "global_position", me.global_position, middle, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "global_position", self.global_position, middle, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(3), "timeout")
	me.queue_free()
	tween.remove_all()
	var light = $Light2D
	$Camera2D.current = false
	TextBox.queue_text("Let's get out of here.")
	yield(get_tree().create_timer(6), "timeout")
	var dog = $"../Dog"
	dog.pause_mode = Node.PAUSE_MODE_PROCESS
	light.shadow_enabled = false
	get_tree().paused = true
	$Sprite.texture = face_left
	tween.interpolate_property(light, "texture_scale", light.texture_scale, 10, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(light, "energy", light.energy, 5, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position:x", self.global_position.x, -600, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(dog, "position:x", dog.global_position.x, -600, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(5), "timeout")
	$"../UILayer/Continue".visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

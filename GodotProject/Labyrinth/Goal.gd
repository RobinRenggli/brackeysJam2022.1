extends Area2D

func _on_Goal_body_entered(body):
	body.on_goal_reached()
	AudioController.get_node("DoorSound").play()

func respawn_at_random_position(times_grown):
	# TODO: remove once goals get genareted when labyrinth grows
	var growth = times_grown*3
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var direction = randi()%4
	#north
	if (direction == 0):
		global_position = Vector2(200 + rand.randi_range(0-growth, 2+growth) * 400, 70-growth*400)
	#south
	elif (direction == 1):
		global_position = Vector2(200 + rand.randi_range(0-growth, 2+growth) * 400, 1200-70+growth*400)
	#east
	elif (direction == 2):
		global_position = Vector2(1200-70+growth*400, 200 + rand.randi_range(0-growth, 2+growth))
	#west
	elif (direction == 3):
		global_position = Vector2(70-growth*400, 200 + rand.randi_range(0-growth, 2+growth))

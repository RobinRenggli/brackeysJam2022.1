extends Area2D

func _on_Goal_body_entered(body):
	body.on_goal_reached()
	respawn_at_random_position()

func respawn_at_random_position():
	# TODO: remove once goals get genareted when labyrinth grows
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	global_position = Vector2(200 + rand.randi_range(0, 5) * 400, 200 + rand.randi_range(0, 5) * 400)

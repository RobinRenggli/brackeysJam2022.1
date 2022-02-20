extends Area2D

func _on_Goal_area_entered(area):
	respawn_at_random_position()
	area.get_parent().on_goal_reached()

func _ready():
	respawn_at_random_position()

func respawn_at_random_position():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	global_position = Vector2(200 + rand.randi_range(0, 5) * 400, 200 + rand.randi_range(0, 5) * 400)

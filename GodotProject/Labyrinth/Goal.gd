extends Area2D

export(String, "N", "W", "E", "S") var entrance_direction

onready var door_N = $"../UILayer/DoorN"
onready var door_W = $"../UILayer/DoorW"
onready var door_E = $"../UILayer/DoorE"
onready var door_S = $"../UILayer/DoorS"

func _on_Goal_body_entered(body):
	match entrance_direction:
		"N":
			door_N.visible = false
		"W":
			door_W.visible = false
		"E":
			door_E.visible = false
		"S":
			door_S.visible = false
	turn_off()
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

func turn_off():
	self.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
func turn_on():
	self.visible = true
	$CollisionShape2D.set_deferred("disabled", false)

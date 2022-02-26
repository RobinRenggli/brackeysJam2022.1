extends KinematicBody2D

onready var player = get_node("../Player")

var dead = false
var spawned = false

export (int) var speed = 100

export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;


func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	if not spawned:
		$BreathingSound.play()
	spawned = true
	
func _on_goal_reached():
	self.queue_free()
	
func _physics_process(delta):
	var direction = self.global_position.direction_to(player.global_position).normalized()
	if (direction.x > 0):
		if (abs(direction.y) > abs(direction.x)):
			if(direction.y > 0):
				$Sprite.texture = face_up
			else:
				$Sprite.texture = face_down
		else:
			$Sprite.texture = face_right
	elif (direction.x < 0):
		if (abs(direction.y) > abs(direction.x)):
			if(direction.y > 0):
				$Sprite.texture = face_up
			else:
				$Sprite.texture = face_down
		else:
				$Sprite.texture = face_left
	move_and_slide(direction * speed)

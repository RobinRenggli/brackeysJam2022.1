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
				$EyeLeftLight.visible = true
				$EyeLeftParticle.visible = true
				$EyeLeftLight.position.x = -32
				$EyeLeftParticle.position.x = -32
				$EyeRightLight.position.x = 48
				$EyeRightParticle.position.x = 48
			else:
				$Sprite.texture = face_down
				$EyeLeftLight.visible = true
				$EyeLeftParticle.visible = true
				$EyeLeftLight.position.x = -32
				$EyeLeftParticle.position.x = -32
				$EyeRightLight.position.x = 48
				$EyeRightParticle.position.x = 48
		else:
			$Sprite.texture = face_right
			$EyeLeftLight.visible = false
			$EyeLeftParticle.visible = false
			$EyeRightLight.position.x = 35
			$EyeRightParticle.position.x = 35
	elif (direction.x < 0):
		if (abs(direction.y) > abs(direction.x)):
			if(direction.y > 0):
				$Sprite.texture = face_up
				$EyeLeftLight.visible = true
				$EyeLeftParticle.visible = true
				$EyeLeftLight.position.x = -32
				$EyeLeftParticle.position.x = -32
				$EyeRightLight.position.x = 48
				$EyeRightParticle.position.x = 48
			else:
				$Sprite.texture = face_down
				$EyeLeftLight.visible = true
				$EyeLeftParticle.visible = true
				$EyeLeftLight.position.x = -32
				$EyeLeftParticle.position.x = -32
				$EyeRightLight.position.x = 48
				$EyeRightParticle.position.x = 48
		else:
			$Sprite.texture = face_left
			$EyeLeftLight.visible = false
			$EyeLeftParticle.visible = false
			$EyeRightLight.position.x = -20
			$EyeRightParticle.position.x = -20
	move_and_slide(direction * speed)

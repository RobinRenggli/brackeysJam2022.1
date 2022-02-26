extends KinematicBody2D

onready var player = get_node("../Player")

onready var ray = $RayCast2D
var dead = false
var start_position
var seen = false

export (int) var speed = 200


export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;

var first_spotted = false

func _ready():
	start_position = self.global_position
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	
func _on_goal_reached():
	self.global_position = start_position
	first_spotted = false
	
func _physics_process(delta):
	ray.set_cast_to(self.global_position.direction_to(player.global_position).normalized()*4000)
	if(ray.is_colliding()):
		var collider = ray.get_collider()
		if(collider == player || collider.get_parent() == player):
			var direction = self.global_position.direction_to(player.global_position).normalized()
			if (direction.x > 0):
				if (abs(direction.y) > abs(direction.x)):
					if(direction.y > 0):
						$Sprite.texture = face_up
						$GuardEnemyParticles.texture = face_up
					else:
						$Sprite.texture = face_down
						$GuardEnemyParticles.texture = face_down
				else:
					$Sprite.texture = face_right
					$GuardEnemyParticles.texture = face_right
			elif (direction.x < 0):
				if (abs(direction.y) > abs(direction.x)):
					if(direction.y > 0):
						$Sprite.texture = face_up
						$GuardEnemyParticles.texture = face_up
					else:
						$Sprite.texture = face_down
						$GuardEnemyParticles.texture = face_down
				else:
					$Sprite.texture = face_left
					$GuardEnemyParticles.texture = face_left
			if(first_spotted):
				if($Timer.time_left > 0):
					pass
				else:
					if not seen:
						$ShadowSpotSound.play()
					seen = true
					move_and_slide(self.global_position.direction_to(player.global_position).normalized() * speed)
			else:
				seen = true
				$ShadowSpotSound.play()
				first_spotted = true
				$Timer.start(1)
		else:
			seen = false

func _on_Hitbox_body_entered(body):
	if not dead:
		AudioController.get_node("Heartbeat1").stop()
		AudioController.get_node("Heartbeat2").stop()
		AudioController.get_node("Heartbeat3").stop()
		AudioController.get_node("Heartbeat4").stop()
		AudioController.get_node("Heartbeat5").stop()
		AudioController.get_node("Heartbeat6").stop()
		AudioController.get_node("DeathSound").play()
	dead = true
	EnemyStorage.stored_enemies = []
	TransitionScreen.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Scenes/GameOverScene.tscn")
	dead == false

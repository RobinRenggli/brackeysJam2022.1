extends KinematicBody2D

onready var player = get_node("../Player")

onready var ray = $RayCast2D
var dead = false
var start_position

export (int) var speed = 300

export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;

func _ready():
	start_position = self.global_position
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	
func _on_goal_reached():
	self.global_position = start_position
	
func _physics_process(delta):
	ray.set_cast_to(self.global_position.direction_to(player.global_position).normalized()*4000)
	if(ray.is_colliding()):
		var collider = ray.get_collider()
		if(collider == player || collider.get_parent() == player):
			move_and_slide(self.global_position.direction_to(player.global_position).normalized() * speed)

func _on_Hitbox_body_entered(body):
	print("hit")
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

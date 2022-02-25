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
	#if not spawned:
		#$BreathingSound.play()
	spawned = true
	
func _on_goal_reached():
	self.queue_free()
	
func _physics_process(delta):
	var direction = self.global_position.direction_to(player.global_position).normalized()
	move_and_slide(direction * speed)


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

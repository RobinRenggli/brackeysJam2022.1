extends KinematicBody2D

export var dogs = [
	preload("res://CollectableObjects/Dog/DarkDog.png"),
	preload("res://CollectableObjects/Dog/LightDog.png"),
]
var picked_up = false
onready var player = get_node("../Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	print("spawned")
	var Rand = RandomNumberGenerator.new()
	Rand.randomize()
	$Sprite.texture = dogs[Rand.randi_range(0, dogs.size() - 1)]
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	$AnimationPlayer.play("Waggle")
	if get_tree().get_nodes_in_group("Dog").size() > 1:
		queue_free()

func _on_PickupArea_body_entered(body):
	if not picked_up:
		AudioController.get_node("KeyItemCollectSound").play()
		AudioController.get_node("DoggySound").play()
	picked_up = true
	Overviewer.dog = true
	body.sanity_counter_ui.sanity_decrease_interval = 30
	body.sanity_counter_ui.get_node("Timer").set_wait_time(30)

func _physics_process(delta):
	if picked_up:
		var velocity = self.global_position.direction_to(player.global_position).normalized() * (max(10, player.speed - 30))
		if is_colliding():
			velocity += get_push_vector() * (max(10, player.speed - 30))
		move_and_slide(velocity)

func is_colliding():
	var areas = $PickupArea.get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var areas = $PickupArea.get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position).normalized()
	return push_vector

func _on_goal_reached():
	if picked_up:
		global_position = player.global_position


func _on_Barktimer_timeout():
	if picked_up:
		AudioController.get_node("DoggySound").play()

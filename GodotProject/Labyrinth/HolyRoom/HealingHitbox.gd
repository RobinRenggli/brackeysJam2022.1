extends Area2D

var colliding_with_player = false
var player
export var healing = 0.5
export var healing_interval = 1.0

func _ready():
	$HealingTimer.set_wait_time(healing_interval) 

func heal_player():
	player.sanity_counter_ui.set_sanity(player.sanity_counter_ui.get_sanity() + healing)


func _on_HealingHitbox_body_entered(body):
	if body.is_in_group("Player") and not colliding_with_player:
		player = body
		colliding_with_player = true
		heal_player()
		$HealingTimer.start()


func _on_HealingHitbox_body_exited(body):
	if body.is_in_group("Player") and colliding_with_player:
		colliding_with_player = false
		$HealingTimer.stop()
		$HealingTimer.set_wait_time(healing_interval) 


func _on_HealingTimer_timeout():
	if colliding_with_player:
		heal_player()

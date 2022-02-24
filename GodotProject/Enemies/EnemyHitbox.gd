extends Area2D

var colliding_with_player = false
var player
export var damage = 1
export var damage_interval = 1

func _ready():
	$DamageTimer.set_wait_time(damage_interval) 

func _on_EnemyHitbox_body_entered(body):
	if body.is_in_group("Player") and not colliding_with_player:
		player = body
		colliding_with_player = true
		damage_player()
		$DamageTimer.start()

func _on_EnemyHitbox_body_exited(body):
	if body.is_in_group("Player") and colliding_with_player:
		colliding_with_player = false
		$DamageTimer.stop()
		$DamageTimer.set_wait_time(damage_interval) 

func _on_DamageTimer_timeout():
	if colliding_with_player:
		damage_player()

func damage_player():
	player.sanity_counter_ui.set_sanity(player.sanity_counter_ui.get_sanity() - damage)

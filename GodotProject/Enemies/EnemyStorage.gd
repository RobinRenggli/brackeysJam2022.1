extends Node

var stored_enemies = []
export (Resource) var StandardEnemy

func _ready():
	pass # Replace with function body.

func store_enemy(info):
	stored_enemies.append(info)

func spawn_enemies():
	for i in range(stored_enemies.size()):
		yield(get_tree().create_timer(2), "timeout")
		var enemy = StandardEnemy.instance()
		get_tree().root.get_node("Labyrinth").add_child(enemy)
		enemy.position_history = stored_enemies[i]
		enemy.start_moving()

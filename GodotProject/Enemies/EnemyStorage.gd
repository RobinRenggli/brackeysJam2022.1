extends Node

var stored_enemies = []
export (Resource) var StandardEnemy

func _ready():
	pass # Replace with function body.

func store_enemy(info):
	stored_enemies.append(info)

func spawn_enemies():
	for i in range(stored_enemies.size()):
		var enemy = StandardEnemy.instance()
		enemy.position_history = stored_enemies[i]
		get_tree().root.get_node("Labyrinth").add_child(enemy)
	yield(get_tree().create_timer(5), "timeout")
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.start_moving()

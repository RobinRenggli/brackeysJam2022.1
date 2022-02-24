extends Node

var stored_enemies = []
export (Resource) var StandardEnemy

func _ready():
	var stored_enemies = []

func store_enemy(info):
	stored_enemies.append(info)

func spawn_enemies():
	for i in range(stored_enemies.size()):
		var enemy = StandardEnemy.instance()
		enemy.position_history = stored_enemies[i]
		get_tree().root.get_node("Labyrinth").add_child(enemy)

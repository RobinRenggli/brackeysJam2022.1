extends Node2D

func _ready():
	Overviewer.connect("goal_reached", self, "_on_goal_reached")
	if get_tree().get_nodes_in_group("Teddy").size() > 1:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("Teddy").visible = true
		body.sanity_counter_ui.max_sanity = 7
		body.sanity_counter_ui.set_sanity(7)
		body.sanity_counter_ui.get_node("SanityUIEmpty").margin_right = 455
		queue_free()

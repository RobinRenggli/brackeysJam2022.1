extends Area2D

func _on_Goal_body_entered(body):
	body.on_goal_reached()
	get_parent().remove_child(self)

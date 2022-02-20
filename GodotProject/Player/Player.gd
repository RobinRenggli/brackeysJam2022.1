extends KinematicBody2D

export (int) var speed = 200
export (Texture) var face_right;
export (Texture) var face_left;
export (Texture) var face_up;
export (Texture) var face_down;

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
		$Sprite.texture = face_right
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 1
		$Sprite.texture = face_left
	elif Input.is_action_pressed('move_down'):
		velocity.y += 1
		$Sprite.texture = face_down
	elif Input.is_action_pressed('move_up'):
		velocity.y -= 1
		$Sprite.texture = face_up
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

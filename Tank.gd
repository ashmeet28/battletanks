extends CharacterBody2D


const MAX_SPEED = 300.0

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("tank_move_forward"):
		velocity.y = -MAX_SPEED
	if Input.is_action_pressed("tank_move_backwards"):
		velocity.y = MAX_SPEED
	
	if Input.is_action_pressed("tank_turn_right"):
		rotate(PI * delta)
	if Input.is_action_pressed("tank_turn_left"):
		rotate(-(PI * delta))
	
	velocity = velocity.rotated(rotation)
	
	move_and_slide()

extends CharacterBody2D

var tank_speed:float = 500.0
var tank_ang_vel:float = PI

var tank_cooldown_time:int = 1000
var missile_last_fired:int = 0

func tank_fire_missile():
	var curr_time = Time.get_ticks_msec()
	if (curr_time > tank_cooldown_time + missile_last_fired):
		var instance = preload("res://tank_missile.tscn").instantiate()
		instance.position = position + Vector2(0, -160).rotated(rotation)
		instance.rotation = rotation
		get_parent().add_child(instance)
		missile_last_fired = curr_time

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("tank_move_forward"):
		velocity.y = -tank_speed
	if Input.is_action_pressed("tank_move_backwards"):
		velocity.y = tank_speed
	
	if Input.is_action_pressed("tank_turn_clockwise"):
		rotate(tank_ang_vel * delta)
	if Input.is_action_pressed("tank_turn_anticlockwise"):
		rotate(-(tank_ang_vel * delta))

	velocity = velocity.rotated(rotation)

	if Input.is_action_pressed("tank_fire"):
		tank_fire_missile()

	move_and_slide()

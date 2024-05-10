extends CharacterBody2D

var max_speed:float = 500.0
var tank_cooldown_time:int = 1000
var missile_last_fired:int = 0

var tank_id:int
var tank_life:int = 100000
var tank_damage_given:int = 0

func _ready():
	missile_last_fired = Time.get_ticks_msec()

func tank_fire_missile():
	var curr_time = Time.get_ticks_msec()
	if (curr_time > tank_cooldown_time + missile_last_fired):
		var instance = preload("res://tank_missile.tscn").instantiate()
		instance.position = position + Vector2(0, -160).rotated(rotation)
		instance.rotation = rotation
		instance.owner_tank_id = tank_id
		get_parent().add_child(instance)
		missile_last_fired = curr_time

func _physics_process(delta):
	if tank_life <= 0:
		queue_free()
		return

	velocity = Vector2.ZERO
	if Input.is_action_pressed("tank_move_forward"):
		velocity.y = -max_speed
	if Input.is_action_pressed("tank_move_backwards"):
		velocity.y = max_speed

	if Input.is_action_pressed("tank_turn_clockwise"):
		rotate(PI * delta)
	if Input.is_action_pressed("tank_turn_anticlockwise"):
		rotate(-(PI * delta))

	velocity = velocity.rotated(rotation)


	if Input.is_action_pressed("tank_fire"):
		tank_fire_missile()

	move_and_slide()

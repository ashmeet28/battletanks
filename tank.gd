extends CharacterBody2D

const MAX_SPEED:float = 500.0

const TANK_COOLDOWN_TIME:int = 500
var missile_last_fired:int = 0

var tank_id:int
var tank_life:int = 100
var tank_damage_given:int = 0

func _ready():
	missile_last_fired = Time.get_ticks_msec()

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("tank_move_forward"):
		velocity.y = -MAX_SPEED
	if Input.is_action_pressed("tank_move_backwards"):
		velocity.y = MAX_SPEED

	if Input.is_action_pressed("tank_turn_clockwise"):
		rotate(PI * delta)
	if Input.is_action_pressed("tank_turn_anticlockwise"):
		rotate(-(PI * delta))

	velocity = velocity.rotated(rotation)


	if Input.is_action_pressed("tank_fire"):
		var curr_time = Time.get_ticks_msec()
		if (curr_time > TANK_COOLDOWN_TIME + missile_last_fired):
			missile_last_fired = curr_time
			var instance = preload("res://tank_missile.tscn").instantiate()
			instance.position = position + Vector2(0, -160).rotated(rotation)
			instance.rotation = rotation
			instance.owner_tank_id = tank_id
			get_parent().add_child(instance)

	move_and_slide()

	if tank_life <= 0:
		queue_free()
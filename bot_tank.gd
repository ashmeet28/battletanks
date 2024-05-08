extends CharacterBody2D

const MAX_SPEED:float = 300.0

const TANK_COOLDOWN_TIME:int = 500
var missile_last_fired:int = 0

var tank_id:int
var tank_life:int = 100
var tank_damage_given:int = 0

func _ready():
	missile_last_fired = Time.get_ticks_msec()

func _physics_process(delta):
	var bot_controller = []

	var bot_sensors = [
		$Area2D3, $Area2D, $Area2D2,
		$Area2D4, $Area2D5,
		$Area2D7, $Area2D8,$Area2D6
	]
	var bot_sensors_data = []
	const MAX_TANK_DISTANCE:float = 1000000.0
	for s in bot_sensors:
		var d:float = MAX_TANK_DISTANCE
		for t in get_tree().get_nodes_in_group("tanks"):
			var curr_d = s.global_position.distance_to(t.global_position)
			if t.tank_id != tank_id && d > curr_d:
				d = curr_d
		bot_sensors_data.append(d)

	for i in range(bot_sensors.size()):
		if bot_sensors[i].has_overlapping_bodies():
			for b in bot_sensors[i].get_overlapping_bodies():
				if b.is_in_group("walls"):
					bot_sensors_data[i] = MAX_TANK_DISTANCE
					break
	print(bot_sensors_data)
	var j:int = 0
	var d:float = MAX_TANK_DISTANCE
	for i in range(bot_sensors_data.size()):
		if bot_sensors_data[i] < d:
			j = i
			d = bot_sensors_data[i]
	print(bot_sensors[j].position)
	
	velocity = Vector2.ZERO
	if bot_sensors[j].position.x > 0:
		rotate(PI * delta)
	elif bot_sensors[j].position.x < 0:
		rotate(-(PI * delta))
	else:
		velocity.y = -MAX_SPEED
	
	velocity = velocity.rotated(rotation)
	move_and_slide()

	if tank_life <= 0:
		queue_free()

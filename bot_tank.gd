extends CharacterBody2D

var tank_speed:float = 500.0
var tank_ang_vel:float = PI

var tank_cooldown_time:int = 1000
var missile_last_fired:int = 0

var target_tank_id:int

func tank_fire_missile():
	var curr_time = Time.get_ticks_msec()
	if (curr_time > tank_cooldown_time + missile_last_fired):
		var instance = preload("res://tank_missile.tscn").instantiate()
		instance.position = position + Vector2(0, -160).rotated(rotation)
		instance.rotation = rotation
		get_parent().add_child(instance)
		missile_last_fired = curr_time

func is_target_tank_in_line_of_sight():
	var p1 = global_position
	var p2 = instance_from_id(target_tank_id).global_position

	if p1.distance_to(p2) > 1000.0:
		return false

	for s in range(-50, 50 + 10, 10):
		var p = p1.direction_to(p2).rotated(PI/2) * s
		var q = PhysicsRayQueryParameters2D.create(p1 + p, p2 + p)
		q.exclude = [get_rid()]
		var r = get_world_2d().direct_space_state.intersect_ray(q)
		if !(r.has("collider")
				and r.collider.is_in_group("tanks")
				and r.collider.get_instance_id() == target_tank_id):
			return false

	return true


func get_rotation_towards_direction(v1, delta):
	var v2 = Vector2.UP.rotated(rotation)

	if v2.cross(v1) > v2.cross(v2.rotated(tank_ang_vel * delta)):
		return 1
	elif v2.cross(v1) < v2.cross(v2.rotated(-(tank_ang_vel * delta))):
		return -1
	return 0

func tank_get_next_position_towards_target_tank():
	var astar = ArenaGlobalVariables.bot_tank_astar
	var p1 = astar.get_closest_point(position)
	var p2 = astar.get_closest_point(instance_from_id(target_tank_id).position)
	var id_path = astar.get_id_path(p1, p2)
	if id_path.size() >= 3:
		return astar.get_point_position(id_path[1])


var bot_controller = [false, false, false, false, false]

func update_bot_controller(delta):
	bot_controller = [false, false, false, false, false]
	
	var r = 0
	
	if is_target_tank_in_line_of_sight():
		r = get_rotation_towards_direction(
					position.direction_to(
							instance_from_id(target_tank_id).position),
					delta)
	else:
		var next_p = tank_get_next_position_towards_target_tank()
		if next_p != null:
			r = get_rotation_towards_direction(
						position.direction_to(next_p),
					delta)
			bot_controller[0] = true

	if r == -1:
		bot_controller[3] = true
	elif r == 1:
		bot_controller[2] = true

	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().is_in_group("tanks"):
			if $RayCast2D.get_collider().get_instance_id() == target_tank_id:
				bot_controller[4] = true

func _physics_process(delta):
	update_bot_controller(delta)

	velocity = Vector2.ZERO

	if bot_controller[0]:
		velocity.y = -tank_speed
	if bot_controller[1]:
		velocity.y = tank_speed
	
	if bot_controller[2]:
		rotate(tank_ang_vel * delta)
	if bot_controller[3]:
		rotate(-(tank_ang_vel * delta))

	velocity = velocity.rotated(rotation)

	if bot_controller[4]:
		tank_fire_missile()

	move_and_slide()

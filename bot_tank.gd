extends CharacterBody2D

var max_speed:float = 250.0
var tank_cooldown_time:int = 1000
var missile_last_fired:int = 0

var tank_id:int
var tank_life:int = 100
var tank_damage_given:int = 0

var target_tank_id:int

func _ready():
	missile_last_fired = Time.get_ticks_msec()
	rotation = randf_range(0, PI*2)

func free_white_square_points():
	for p in get_tree().get_nodes_in_group("square_points"):
		p.queue_free()

func spaw_white_square_points(new_square_points):
	for p in new_square_points:
		var instance = preload("res://white_sqaure_point.tscn").instantiate()
		instance.position = Vector2(p.x, p.y)
		get_parent().add_child(instance)

func get_target_tank():
	for t in get_tree().get_nodes_in_group("tanks"):
		if t.tank_id == target_tank_id:
			return t

func is_target_tank_in_line_of_sight():
	free_white_square_points()

	var p1 = global_position
	var p2 = get_target_tank().global_position
	if p1.distance_to(p2) > 1500.0:
		return false
	var ray_colliding_count:int = 0
	var p = p1.direction_to(p2).rotated(PI/2) * 50

	spaw_white_square_points([p1-p, p2-p,p1+p, p2+p])
	var q = PhysicsRayQueryParameters2D.create(p1 + p, p2 + p)
	q.exclude = [self]
	var r = get_world_2d().direct_space_state.intersect_ray(q)
	if !(r.has("collider") && r.collider.is_in_group("tanks") && r.collider.tank_id == target_tank_id):
		return false
	
	q = PhysicsRayQueryParameters2D.create(p1 - p, p2 - p)
	q.exclude = [self]
	r = get_world_2d().direct_space_state.intersect_ray(q)
	if !(r.has("collider") && r.collider.is_in_group("tanks") && r.collider.tank_id == target_tank_id):
		return false

	return true

func tank_rotate_towards_direction(v1, delta):
	var v2 = Vector2.UP.rotated(rotation)
	if v2.cross(v1) > 0:
		rotate(PI * delta)
	elif v2.cross(v1) < -0:
		rotate(-(PI * delta))

func tank_get_next_position_towards_target_tank():
	var astar = ArenaGlobalVariables.bot_tank_astar
	var p1 = astar.get_closest_point(position)
	var p2 = astar.get_closest_point(get_target_tank().position)
	var id_path = astar.get_id_path(p1, p2)
	if id_path.size() >= 3:
		return astar.get_point_position(id_path[1])

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
	if is_target_tank_in_line_of_sight():
		tank_rotate_towards_direction(position.direction_to(get_target_tank().position), delta)
	else:
		var next_p = tank_get_next_position_towards_target_tank()
		if next_p != null:
			tank_rotate_towards_direction(position.direction_to(next_p), delta)
			velocity = Vector2.UP.rotated(rotation) * max_speed

	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().is_in_group("tanks"):
			if $RayCast2D.get_collider().tank_id == target_tank_id:
				tank_fire_missile()

	move_and_slide()

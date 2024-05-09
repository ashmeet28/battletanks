extends CharacterBody2D

const MAX_SPEED:float = 500.0

const TANK_COOLDOWN_TIME:int = 500
var missile_last_fired:int = 0

var tank_id:int
var tank_life:int = 100
var tank_damage_given:int = 0

var target_tank_id:int

func _ready():
	missile_last_fired = Time.get_ticks_msec()
	rotation = randf_range(0, 2*PI)

func _physics_process(delta):
	var target_tank_position
	for t in get_tree().get_nodes_in_group("tanks"):
		if t.tank_id == target_tank_id:
			target_tank_position = t.position
	var p1 = position
	var p2 = target_tank_position

	var p1id = ArenaGlobalVariables.bot_tank_astar.get_available_point_id()
	ArenaGlobalVariables.bot_tank_astar.add_point(p1id, Vector2(p1.x, p1.y))
	ArenaGlobalVariables.bot_tank_astar.connect_points(
		p1id,
		ArenaGlobalVariables.bot_tank_astar.get_closest_point(Vector2(p1.x, p1.y)), false)
	
	var p2id = ArenaGlobalVariables.bot_tank_astar.get_available_point_id()
	ArenaGlobalVariables.bot_tank_astar.add_point(p2id, Vector2(p2.x, p2.y))
	ArenaGlobalVariables.bot_tank_astar.connect_points(
		ArenaGlobalVariables.bot_tank_astar.get_closest_point(Vector2(p2.x, p2.y)),
		p2id, false)

	var p_list = ArenaGlobalVariables.bot_tank_astar.get_id_path(p1id, p2id)
	if p_list.size() > 0:
		var p_next = ArenaGlobalVariables.bot_tank_astar.get_point_position(p_list[0])
		var v = position.direction_to(p_next).rotated(rotation)
		print(v)
		if v.x < 0:
			rotate(-(PI * delta))
		if v.x > 0:
			rotate((PI * delta))
	ArenaGlobalVariables.bot_tank_astar.remove_point(p1id)
	ArenaGlobalVariables.bot_tank_astar.remove_point(p2id)
	velocity = Vector2.ZERO
	velocity.y = -MAX_SPEED
	velocity = velocity.rotated(rotation)
	move_and_slide()
	if tank_life <= 0:
		queue_free()

extends CharacterBody2D

const MAX_SPEED:float = 300.0
const TANK_COOLDOWN_TIME:int = 500
var missile_last_fired:int = 0

var tank_id:int
var tank_life:int = 100
var tank_damage_given:int = 0

var target_tank_id:int

func _ready():
	missile_last_fired = Time.get_ticks_msec()
	rotation = randf_range(0, PI*2)
func show_astar_path(id_path):
	for l in get_tree().get_nodes_in_group("labels"):
		l.queue_free()
	for point_id in id_path:
		var l = Label.new()
		l.position = ArenaGlobalVariables.bot_tank_astar.get_point_position(point_id)
		l.text = str(point_id)
		l.scale = Vector2(4, 4)
		l.add_to_group("labels")
		get_parent().add_child(l)
	
func _physics_process(delta):
	var astar = ArenaGlobalVariables.bot_tank_astar

	var p1 = astar.get_closest_point(position)
	var p2 = astar.get_closest_point($"/root/Arena/Tank".position)
	var id_path = astar.get_id_path(p1, p2)
	if id_path.size() >= 3:
		var next_pos = astar.get_point_position(id_path[1])
		var v1 = position.direction_to(next_pos)
		var v2 = Vector2.UP.rotated(rotation)
		if v2.cross(v1) > 0.05:
			rotate(PI * delta)
		elif v2.cross(v1) < -0.05:
			rotate(-(PI * delta))
		velocity = Vector2.UP.rotated(rotation) * MAX_SPEED
		move_and_slide() 

	#show_astar_path(id_path)
		
	if tank_life <= 0:
		queue_free()

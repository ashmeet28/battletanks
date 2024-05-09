extends Node2D

var current_tank_id:int = 0
func get_next_tank_id():
	current_tank_id += 1
	return current_tank_id

#func tank_path_points_spaw():
	#var tank_path_points = []
	#var sl = 250
	#for y in range(17):
		#for x in range(17):
			#tank_path_points.append([[(x*sl)-2000,(y*sl)-2000],1])
	#for i in range(tank_path_points.size()):
		#var instance = preload("res://tank_point_validator.tscn").instantiate()
		#instance.position = Vector2(tank_path_points[i][0][0], tank_path_points[i][0][1])
		#instance.validator_id = i
		#add_child(instance)
	#return tank_path_points
#
#func tank_path_points_validate(tank_path_points):
	#for p in get_tree().get_nodes_in_group("point_validators"):
		#if p.has_overlapping_bodies():
			#for b in p.get_overlapping_bodies():
				#if b.is_in_group("walls"):
					#tank_path_points[p.validator_id][1] = 0
					#p.queue_free()
					#break

#func tank_path_points_get_invalid_point_indexes(p):
	#var invalid_p = []
		#for i in range(p.size()):
			#if p[i][1] == 0:
				#invalid_p.append(i)
	#return invalid_p
	
var ptank
var btank

func _ready():
	var instance = preload("res://tank.tscn").instantiate()
	instance.position = Vector2(0, 500)
	instance.tank_id = get_next_tank_id()
	ptank = instance
	add_child(instance)
	
	var instance2 = preload("res://bot_tank.tscn").instantiate()
	instance2.position = Vector2(600, 1100)
	instance2.tank_id = get_next_tank_id()
	btank = instance2
	add_child(instance2)

func _process(_delta):
	var astar = ArenaGlobalVariables.bot_tank_astar
	var p1 = astar.get_closest_point(btank.position)
	var p2 = astar.get_closest_point(ptank.position)
	var p_list = astar.get_id_path(p1, p2)
	for p in get_tree().get_nodes_in_group("point_validators"):
		p.queue_free()
	
	for i in p_list:
		var instance = preload("res://tank_point_validator.tscn").instantiate()
		instance.position = astar.get_point_position(i)
		add_child(instance)


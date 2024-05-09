extends Node2D

var next_tank_id:int = 1

#func tank_path_points_spaw():
	#var tank_path_points = []
	#for y in range(17):
		#for x in range(17):
			#tank_path_points.append([[(x*250)-2000,(y*250)-2000],1])
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
#
#var tank_path_points

func _ready():
	var instance = preload("res://tank.tscn").instantiate()
	instance.position = Vector2(0, 500)
	instance.tank_id = next_tank_id
	next_tank_id += 1
	add_child(instance)
	
	var instance2 = preload("res://bot_tank.tscn").instantiate()
	instance2.position = Vector2(600, 1100)
	instance2.tank_id = next_tank_id
	next_tank_id += 1
	add_child(instance2)

func _physics_process(_delta):
	pass

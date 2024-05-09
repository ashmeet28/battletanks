extends Node2D

var current_tank_id:int = 0
func get_next_tank_id():
	current_tank_id += 1
	return current_tank_id

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
	var p1 = ArenaGlobalVariables.bot_tank_astar.get_closest_point(btank.position)
	var p2 = ArenaGlobalVariables.bot_tank_astar.get_closest_point(ptank.position)
	var p_list = ArenaGlobalVariables.bot_tank_astar.get_id_path(p1, p2)
	for p in get_tree().get_nodes_in_group("point_validators"):
		p.queue_free()
	
	for i in p_list:
		var instance = preload("res://tank_point_validator.tscn").instantiate()
		instance.position = ArenaGlobalVariables.bot_tank_astar.get_point_position(i)
		instance.validator_id = i
		add_child(instance)



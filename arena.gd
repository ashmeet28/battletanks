extends Node2D

var next_tank_id:int = 1
	
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

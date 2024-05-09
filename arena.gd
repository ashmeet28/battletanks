extends Node2D

var current_tank_id:int = 0
func get_next_tank_id():
	current_tank_id += 1
	return current_tank_id

func _ready():
	var instance = preload("res://tank.tscn").instantiate()
	instance.position = Vector2(0, 500)
	instance.tank_id = get_next_tank_id()
	add_child(instance)
	
	var instance2 = preload("res://bot_tank.tscn").instantiate()
	instance2.position = Vector2(600, 700)
	instance2.tank_id = get_next_tank_id()
	add_child(instance2)

func _process(_delta):
	pass


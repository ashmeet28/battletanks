extends Node2D

func _ready():

	var instance = preload("res://tank.tscn").instantiate()
	instance.position = Vector2(0, 400)
	add_child(instance)
	
	var instance2 = preload("res://bot_tank.tscn").instantiate()
	instance2.position = Vector2(0, -400)
	instance2.target_tank_id = instance.get_instance_id()
	add_child(instance2)

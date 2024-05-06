extends Node2D

func _ready():
	var instance = preload("res://tank.tscn").instantiate()
	add_child(instance)
	var instance2 = preload("res://tank.tscn").instantiate()
	instance2.is_ai_controlled = true
	instance2.position.x += 250
	add_child(instance2)

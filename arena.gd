extends Node2D

var next_tank_id:int = 1

func _on_tank_shot_missile(missile_position, missile_rotation, tank_id):
	var instance = preload("res://tank_missile.tscn").instantiate()
	instance.position = missile_position
	instance.rotation = missile_rotation
	instance.owner_tank_id = tank_id
	add_child(instance)
	
func _ready():
	var instance = preload("res://tank.tscn").instantiate()
	instance.position = Vector2(0, 500)
	instance.tank_id = next_tank_id
	next_tank_id += 1
	instance.tank_shot_missile.connect(_on_tank_shot_missile)
	add_child(instance)

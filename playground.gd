extends Node2D


func _ready():
		var instance = preload("res://tank.tscn").instantiate()
		$Camera2D.enabled = false
		instance.get_node("Camera2D").enabled = true
		add_child(instance)


extends Area2D

var missile_speed:float = 1500.0

func _physics_process(delta):
	position += Vector2.UP.rotated(rotation) * (missile_speed * delta)
	if has_overlapping_bodies():
		queue_free()

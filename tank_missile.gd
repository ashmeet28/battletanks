extends Area2D

var missile_speed:float = 1500.0
var is_collided_with_tank:bool = false
var owner_tank_id:int

func _physics_process(delta):
	position += Vector2.UP.rotated(rotation) * (missile_speed * delta)
	if has_overlapping_bodies():
		for b in get_overlapping_bodies():
			if b.is_in_group("tanks") && !is_collided_with_tank:
				b.tank_life -= 25
				if is_instance_id_valid(owner_tank_id):
					instance_from_id(owner_tank_id).tank_damage_given += 25
				is_collided_with_tank = true
		queue_free()

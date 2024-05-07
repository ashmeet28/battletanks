extends Area2D

const SPEED:float = 1500.0
var is_collided_with_tank:bool = false
var owner_tank_id:int

func _physics_process(delta):
	position += Vector2.UP.rotated(rotation) * (SPEED * delta)
	if has_overlapping_bodies():
		for b in get_overlapping_bodies():
			if b.is_in_group("tanks") && !is_collided_with_tank:
				b.tank_life -= 25
				for t in get_tree().get_nodes_in_group("tanks"):
					if t.tank_id == owner_tank_id:
						t.tank_damage_given += 25
						break
				is_collided_with_tank = true
		queue_free()

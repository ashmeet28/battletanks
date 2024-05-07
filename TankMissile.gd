extends CharacterBody2D


const SPEED = 1500.0
var is_collided_with_tank = false
var owner_tank_id:int

func _ready():
	velocity = Vector2.UP.rotated(rotation) * SPEED
	
func _physics_process(_delta):
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() != null && collision.get_collider().is_in_group("tanks") && !is_collided_with_tank:
			collision.get_collider().tank_life -= 25
			if collision.get_collider().tank_life <= 0:
				for t in get_tree().get_nodes_in_group("tanks"):
					if t.tank_id == owner_tank_id:
						t.tank_damage += 25
						break
			is_collided_with_tank = true
		queue_free()
	

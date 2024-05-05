extends CharacterBody2D


const SPEED = 1500.0

func _ready():
	velocity = Vector2.UP.rotated(rotation) * SPEED
	
func _physics_process(_delta):
	move_and_slide()

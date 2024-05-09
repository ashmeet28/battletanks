extends CharacterBody2D

const MAX_SPEED:float = 500.0

const TANK_COOLDOWN_TIME:int = 500
var missile_last_fired:int = 0

var tank_id:int
var tank_life:int = 100
var tank_damage_given:int = 0

func _ready():
	missile_last_fired = Time.get_ticks_msec()

func _physics_process(_delta):
	velocity = Vector2.ZERO

	velocity = velocity.rotated(rotation)
	move_and_slide()

	if tank_life <= 0:
		queue_free()

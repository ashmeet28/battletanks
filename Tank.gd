extends CharacterBody2D

func neural_network_layer_create(input_neurons_count, output_neurons_count):
	var new_layer = {"biases":[], "weights":[], "temp_outputs":[]}
	for n_o in range(output_neurons_count):
		new_layer["biases"].append(0.0)
		new_layer["weights"].append([])
		new_layer["temp_outputs"].append(0.0)
		for n_i in range(input_neurons_count):
			new_layer["weights"][n_o].append(0.0)
	return new_layer

func neural_network_create(layers_design):
	var new_neural_network = {"layers":[]}
	for i in range(layers_design.size() - 1):
		new_neural_network["layers"].append(neural_network_layer_create(layers_design[i], layers_design[i+1]))
	return new_neural_network

func neural_network_layer_process(neurons_layer, input_values):
	for i in range(neurons_layer["weights"].size()):
		neurons_layer["temp_outputs"][i] = neurons_layer["biases"][i]
		for j in range(neurons_layer["weights"][0].size()):
			neurons_layer["temp_outputs"][i] += input_values[j] * neurons_layer["weights"][i][j]
			if neurons_layer["temp_outputs"][i] < 0.0:
				neurons_layer["temp_outputs"][i] = 0.0

func neural_network_process(neural_network, input_values):
	neural_network_layer_process(neural_network["layers"][0], input_values)
	for i in range(1, neural_network["layers"].size()):
		neural_network_layer_process(neural_network["layers"][i], neural_network["layers"][i-1]["temp_outputs"])
	return neural_network["layers"][-1]["temp_outputs"]

func neural_network_layer_mutate(neurons_layer, bias_mut_val, weight_mut_val):
	for i in range(neurons_layer["weights"].size()):
		neurons_layer["biases"][i] = neurons_layer["biases"][i] + randf_range(-(bias_mut_val), bias_mut_val)
		for j in range(neurons_layer["weights"][0].size()):
			neurons_layer["weights"][i][j] = neurons_layer["weights"][i][j] + randf_range(-(weight_mut_val), weight_mut_val)

func neural_network_mutate(neural_network, bias_mut_val, weight_mut_val):
	for i in range(neural_network["layers"].size()):
		neural_network_layer_mutate(neural_network["layers"][i], bias_mut_val, weight_mut_val)


var is_ai_controlled:bool = false

const MAX_SPEED = 500.0

const MISSILE_COOLDOWN:int = 60
var missile_last_fired:int = 0

var tank_id:int

var tank_life:int = 100
var tank_kills:int = 0

var tank_neural_network

func _ready():
	tank_id = $"/root/PlaygroundGlobalVariables".next_tank_id
	$"/root/PlaygroundGlobalVariables".next_tank_id += 1
	missile_last_fired = Engine.get_physics_frames() - (MISSILE_COOLDOWN*2)
	if is_ai_controlled:
		$Camera2D.enabled = false

func _physics_process(delta):
	var nn_output = []
	if !is_ai_controlled && (Engine.get_physics_frames() % 30) == 0:
		var nn_input = []
		var single_input = 0.0
		
		single_input = 0.0
		if $RayCast2D.is_colliding() && $RayCast2D.get_collider().is_in_group("tanks"):
			single_input = 1.0
		nn_input.append(single_input)
		
		single_input = 10000.0
		if $RayCast2D.is_colliding() && $RayCast2D.get_collider().is_in_group("tanks"):
			single_input = position.distance_to($RayCast2D.get_collision_point())
		nn_input.append(single_input)
		
		single_input = 0.0
		if $RayCast2D.is_colliding() && $RayCast2D.get_collider().is_in_group("walls")	:
			single_input = 1.0
		nn_input.append(single_input)
		
		single_input = 10000.0
		if $RayCast2D.is_colliding() && $RayCast2D.get_collider().is_in_group("walls"):
			single_input = position.distance_to($RayCast2D.get_collision_point())
		nn_input.append(single_input)
		
		single_input = 0.0
		for b in $FrontArea2D.get_overlapping_bodies():
			if b.is_in_group("walls"):
				single_input = 1.0
		nn_input.append(single_input)

		single_input = 0.0
		for b in $BackArea2D.get_overlapping_bodies():
			if b.is_in_group("walls"):
				single_input = 1.0
		nn_input.append(single_input)

		var area_sensors_for_tanks = [$Area2D2,$Area2D3,$Area2D4,
		$Area2D5,$Area2D6,$Area2D7,
		$Area2D8,$Area2D9,$Area2D10,
		$Area2D11,$Area2D12,$Area2D13,
		$Area2D14,$Area2D15,$Area2D16,
		$Area2D17,$Area2D18,$Area2D19,
		$Area2D22]
		
		for a in area_sensors_for_tanks:
			single_input = 0.0
			for b in a.get_overlapping_bodies():
				if b.is_in_group("tanks"):
					single_input = 1.0
			nn_input.append(single_input)
		print(nn_input)
		#neural_network_process(tank_neural_network, [])

	velocity = Vector2.ZERO
	if Input.is_action_pressed("tank_move_forward") && !is_ai_controlled:
		velocity.y = -MAX_SPEED
	if Input.is_action_pressed("tank_move_backwards") && !is_ai_controlled:
		velocity.y = MAX_SPEED
	
	if Input.is_action_pressed("tank_turn_right") && !is_ai_controlled:
		rotate(PI * delta)
	if Input.is_action_pressed("tank_turn_left") && !is_ai_controlled:
		rotate(-(PI * delta))
		
	velocity = velocity.rotated(rotation)
	
	move_and_slide()

	if Input.is_action_pressed("tank_fire") && !is_ai_controlled:
		var curr_frame = Engine.get_physics_frames()
		if (curr_frame > MISSILE_COOLDOWN + missile_last_fired) && !($FrontArea2D.has_overlapping_bodies()):
			missile_last_fired = curr_frame
			var instance = preload("res://tank_missile.tscn").instantiate()
			instance.position = position + Vector2(0, -160).rotated(rotation)
			instance.rotation = rotation
			instance.owner_tank_id = tank_id
			get_parent().add_child(instance)

	if tank_life <= 0:
		queue_free()

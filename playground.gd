extends Node2D

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

func _ready():
	#var instance = preload("res://tank.tscn").instantiate()
	#add_child(instance)
	for i in range(4):
		var instance2 = preload("res://tank.tscn").instantiate()
		instance2.is_ai_controlled = true
		instance2.position.x += randf_range(-1000, 1000)
		instance2.position.y += randf_range(-1000, 1000)
		instance2.tank_neural_network = neural_network_create([6, 5, 5])
		neural_network_mutate(instance2.tank_neural_network, 1, 1)
		add_child(instance2)
	

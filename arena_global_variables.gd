extends Node


var bot_tank_astar

func init_bot_tank_astar():
	var bot_tank_invalid_path_points = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 33, 34, 50, 51, 55, 56, 62, 63, 67, 68, 71, 72, 73, 79, 80, 81, 84, 85, 88, 89, 97, 98, 101, 102, 118, 119, 126, 127, 128, 135, 136, 143, 144, 145, 152, 153, 160, 161, 162, 169, 170, 186, 187, 190, 191, 199, 200, 203, 204, 207, 208, 209, 215, 216, 217, 220, 221, 225, 226, 232, 233, 237, 238, 254, 255, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288]
	var bot_tank_manual_invalid_path_points = [39,40,57,87,104,105,61,44,45,99,116,115,183,184,201,231,248,249,172,173,189,227,244,243]

	bot_tank_astar = AStar2D.new()
	var sl = 250
	for y in range(17):
		for x in range(17):
			var i = (y * 17) + x
			bot_tank_astar.add_point(i, Vector2((x*sl)-2000, (y*sl)-2000))

	for i in bot_tank_invalid_path_points:
		bot_tank_astar.remove_point(i)

	for i in bot_tank_manual_invalid_path_points:
		bot_tank_astar.remove_point(i)

	var connection_offsets = [
		[-sl, -sl], [0, -sl], [sl, -sl],
		[-sl, 0], [sl, 0],
		[-sl, sl], [0, sl], [sl, sl]]

	for i in bot_tank_astar.get_point_ids():
		var p1 = bot_tank_astar.get_point_position(i)
		for j in bot_tank_astar.get_point_ids():
			var p2 = bot_tank_astar.get_point_position(j)
			for c_offset in connection_offsets:
				if c_offset[0] + p1.x == p2.x && c_offset[1] + p1.y == p2.y:
					bot_tank_astar.connect_points(i, j)

func _ready():
	init_bot_tank_astar()
	

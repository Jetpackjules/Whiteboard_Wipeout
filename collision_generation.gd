extends Node

onready var collision_parent = $testCamera/VBoxContainer/ViewportContainer/Viewport/StaticBody2D
onready var texture_rect = $testCamera/VBoxContainer/ViewportContainer/Viewport/TextureRect

onready var viewport = $testCamera/VBoxContainer/ViewportContainer/Viewport

var stack_log = {}
export var visual_enabled = false  # Set this value to true or false based on your preference
onready var Visuals = $testCamera/VBoxContainer/ViewportContainer/Viewport/Visuals

signal update_visuals
signal update_old_visuals

var old_clusters = []




func _draw_visual(cluster):
	if visual_enabled:
		emit_signal("update_old_visuals", old_clusters)
		emit_signal("update_visuals", cluster)
		yield(get_tree(), "idle_frame")

func clear_visuals():
	Visuals.update_visuals([])

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func scan():
	yield(get_tree(), "idle_frame")
	delete_children(collision_parent)
	if visual_enabled:
		yield(generate_collisions(), "completed")
	else:
		generate_collisions()

var nearest_neighbor_total_time = 0
var nearest_neighbor_new_total_time = 0


func generate_collisions():
	var img = viewport.get_texture().get_data()

	img.lock()
	bitmap_test(img)
	
	
func generate_collisions_old():
	var traveling_salesman_total_time = 0    # Add a variable to accumulate the total time spent on create_collision_polygon
	var create_collision_polygon_total_time = 0

#	-----------------------------
	
	var img = viewport.get_texture().get_data()
#	print(img.get_width())

	img.lock()
	bitmap_test(img)
	
	var points_visited = {}
	var clusters = []

	stack_log.clear()

	var step_size = 4  # You can adjust this value depending on your needs
	
	for x in range(0, img.get_width(), step_size):
		for y in range(0, img.get_height(), step_size):
#			print(img.get_pixel(x, y).r)
			if img.get_pixel(x, y).r == 1 and not Vector2(x, y) in points_visited:
				var cluster
				if visual_enabled:
					cluster = yield(flood_fill_edge_pixels(img, Vector2(x, y), points_visited), "completed")
				else:
					cluster = flood_fill_edge_pixels(img, Vector2(x, y), points_visited)
				if len(cluster) > 6:
					clusters.append(cluster)
	
	var start_time = OS.get_ticks_msec()
	for cluster in clusters:
		
#		print("CLUSTER!")

		# Measure the time spent on each traveling_salesman() call
		var start_time_traveling_salesman = OS.get_ticks_msec()
		var hull = traveling_salesman(cluster, 10)
		traveling_salesman_total_time += OS.get_ticks_msec() - start_time_traveling_salesman

#		var hull = cluster
#		print("HULLED!")
		
		if hull and len(hull)>2:
			#print(str(hull).replace("[", "").replace("]", "").replace("(", "[").replace(")", "]"))
			# Measure the time spent on each create_collision_polygon() call
			var start_time_create_collision_polygon = OS.get_ticks_msec()
			var collision_shape = create_collision_polygon(img, hull)
			collision_parent.add_child(collision_shape)
			create_collision_polygon_total_time += OS.get_ticks_msec() - start_time_create_collision_polygon
			
		
		if visual_enabled:
			yield(get_tree(), "idle_frame")  # Add this line to allow the engine to update the visuals
#	print("DONE")
	# Print the total time spent on traveling salesmen
#	print("Total time spent on traveling salesmen:         ", traveling_salesman_total_time, "ms")
	# Print the total time spent on create_collision_polygon
	print("Total time spent on create_collision_polygon:   ", create_collision_polygon_total_time, "ms")
	print("Total time spent on nearest_neighbor:           ", nearest_neighbor_total_time, "ms")	
	print("Total time spent on NEW nearest_neighbor:       ", nearest_neighbor_new_total_time, "ms")	
	return {}  # Add this line to signal the completion of the coroutine





func flood_fill_edge_pixels(img: Image, start: Vector2, points_visited: Dictionary) -> Array:
	var stack = [start]
	var cluster = []
	var cluster_edge = []

	while stack:
		var point = stack.pop_front()
		points_visited[point] = true

		var neighbors = [
			Vector2(point.x - 1, point.y),
			Vector2(point.x + 1, point.y),
			Vector2(point.x, point.y - 1),
			Vector2(point.x, point.y + 1),
			Vector2(point.x - 1, point.y -1),
			Vector2(point.x + 1, point.y +1),
			Vector2(point.x +1, point.y - 1),
			Vector2(point.x -1, point.y + 1)
		]

		var is_edge_pixel = false
		var edge_pixel_sum = Vector2.ZERO
		var edge_pixel_count = 0

		for neighbor in neighbors:
			if (neighbor.x >= 0 and neighbor.x < img.get_width() and neighbor.y >= 0 and neighbor.y < img.get_height()):
				if (not neighbor in points_visited) and (img.get_pixel(neighbor.x, neighbor.y).r == 1) and (not neighbor in stack):
					stack.append(neighbor)
					points_visited[neighbor] = true
					cluster.append(neighbor)

				elif img.get_pixel(neighbor.x, neighbor.y).r == 0:
					is_edge_pixel = true
					edge_pixel_sum += point
					edge_pixel_count += 1

		if is_edge_pixel and edge_pixel_count > 0:
			cluster_edge.append(edge_pixel_sum / edge_pixel_count)

		if visual_enabled:
			_draw_visual(cluster_edge) 
			yield(get_tree(), "idle_frame") 

	if visual_enabled:
		if cluster_edge.size() > 0:
			old_clusters.append(cluster_edge)

	return cluster_edge


func create_collision_polygon(img, points: Array) -> CollisionPolygon2D:
	var img_height = img.get_height()  # Get the image height
	for i in range(points.size()):
		points[i].y = img_height - points[i].y  # Invert the Y-axis for each point

	
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.build_mode = 0
		# Set the polygon points for the CollisionPolygon2D
	print(points.size())
	collision_polygon.polygon = points

	return collision_polygon


	
func distance(point1, point2):
	return sqrt(pow(point1[0] - point2[0], 2) + pow(point1[1] - point2[1], 2))


func nearest_neighbor(points, start_point, threshold=null):
	var unvisited_points = points.duplicate()
	unvisited_points.erase(start_point)
	var current_point = start_point
	var tour = [start_point]

	while unvisited_points:
		var candidates = []

		for point in unvisited_points:
			var dist = distance(current_point, point)
			candidates.append([point, dist])

		if threshold != null:  # Change this line
			var candidates_filtered = []
			for candidate in candidates:
				if candidate[1] <= threshold:
					candidates_filtered.append(candidate)
			candidates = candidates_filtered

		if not candidates:
			break

		var next_candidate = candidates[0]
		for candidate in candidates:  # Change this loop
			if candidate[1] < next_candidate[1]:
				next_candidate = candidate

		var next_point = next_candidate[0]
		tour.append(next_point)
		unvisited_points.erase(next_point)
		current_point = next_point

	return tour

func create_grid(points, cell_size):
	var grid = {}
	for point in points:
		var grid_key = Vector2(int(point.x / cell_size), int(point.y / cell_size))
		if not grid.has(grid_key):
			grid[grid_key] = []
		grid[grid_key].append(point)
	return grid

func get_neighbors(grid, point, cell_size):
	var grid_key = Vector2(int(point.x / cell_size), int(point.y / cell_size))
	var neighbors = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			var neighbor_key = grid_key + Vector2(x, y)
			if grid.has(neighbor_key):
				for neighbor in grid[neighbor_key]:
					neighbors.append(neighbor)
	return neighbors

func get_neighbors_with_radius(grid, point, cell_size, search_radius):
	var grid_key = Vector2(int(point.x / cell_size), int(point.y / cell_size))
	var neighbors = []
	var search_radius_cells = int(search_radius / cell_size) + 1
	for x in range(-search_radius_cells, search_radius_cells + 1):
		for y in range(-search_radius_cells, search_radius_cells + 1):
			var neighbor_key = grid_key + Vector2(x, y)
			if grid.has(neighbor_key):
				for neighbor in grid[neighbor_key]:
					neighbors.append(neighbor)
	return neighbors

func nearest_neighbor_new(points, start_point, threshold=null, cell_size=2, search_radius=10):
	var unvisited_points = points.duplicate()
	unvisited_points.erase(start_point)
	var current_point = start_point
	var tour = [start_point]

	var grid = create_grid(unvisited_points, cell_size)

	while unvisited_points:
		var min_distance = INF
		var next_point = null
		var neighbors = get_neighbors_with_radius(grid, current_point, cell_size, search_radius)

		for point in neighbors:
			var dist = distance(current_point, point)
			if (threshold == null or dist <= threshold) and dist < min_distance:
				min_distance = dist
				next_point = point

		if next_point == null:
			break

		tour.append(next_point)
		unvisited_points.erase(next_point)
		var grid_key = Vector2(int(next_point.x / cell_size), int(next_point.y / cell_size))
		grid[grid_key].erase(next_point)
		current_point = next_point

	return tour

func bitmap_test(in_image):

#	var new_img = Image.new()
#	new_img.load("res://assets/WIN_20230502_12_30_00_Pro.jpg")
#	in_image = new_img

#	in_image.lock()
#	var test_pixel = in_image.get_pixel(700,600)
	print(in_image.get_size())
#	var ten = in_image.get_data()
	
	print(in_image.detect_alpha())
	
	
	var bitmap = BitMap.new()
	var image_data = (in_image.get_data())
#	bitmap.create_from_data()
	bitmap.create_from_image_alpha(in_image)
	print(bitmap.get_true_bit_count())

#--------------------------------------------------------

	
	var texture = viewport.get_texture()
	print(texture.get_size())
#	print(bitmap.data)
	print(bitmap.get_size())
	var size = 0
	var total = 0
	for pixel in bitmap.data["data"]:
		total += 1
		if pixel != 255:
			size+=1
	print(total)
	print(size)

	var new_size = Rect2(Vector2(115, 0), Vector2(texture.get_size().x - 115*2, texture.get_size().y))
	var new_polys = bitmap.opaque_to_polygons(new_size, 0.1)
	print(new_polys)
	print("DONE")
	for shape in new_polys:
		print("making shape...")
		var collision_shape = create_collision_polygon(in_image, shape)
		collision_parent.add_child(collision_shape)
	print("ALL DONE")

func traveling_salesman(points, threshold=null):
	if points.size() <= 1:
		return points

	var start_point = points[0]
	for point in points:
		if point[0] < start_point[0]:
			start_point = point
		elif point[0] == start_point[0]:
			if point[1] < start_point[1]:
				start_point = point

#	print("START POINT:")
#	print(start_point)
	var start_time_nearest_neighbor_new = OS.get_ticks_msec()
	var tour = nearest_neighbor_new(points, start_point, threshold)
	nearest_neighbor_new_total_time += OS.get_ticks_msec() - start_time_nearest_neighbor_new

	var start_time_nearest_neighbor = OS.get_ticks_msec()
#	tour = nearest_neighbor(points, start_point, threshold)
	nearest_neighbor_total_time += OS.get_ticks_msec() - start_time_nearest_neighbor

	
	return tour


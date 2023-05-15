#extends Reference
#
#const THRESHOLD = 128
#
#func compute_contours(edge_image: Image) -> Array:
#	var contours := []
#	var width := edge_image.get_width()
#	var height := edge_image.get_height()
#
#	for y in range(0, height - 1):
#		for x in range(0, width - 1):
#			var square := _get_square(edge_image, x, y)
#			var segments := _get_segments(square)
#			for segment in segments:
#				_add_segment_to_contours(contours, segment)
#
#	return contours
#
#func _get_square(edge_image: Image, x: int, y: int) -> Array:
#	return [
#		edge_image.get_pixel(x, y).r > THRESHOLD,
#		edge_image.get_pixel(x + 1, y).r > THRESHOLD,
#		edge_image.get_pixel(x + 1, y + 1).r > THRESHOLD,
#		edge_image.get_pixel(x, y + 1).r > THRESHOLD
#	]
#
#func _get_segments(square: Array) -> Array:
#	var segments := []
#	var index := int(square[0]) << 3 | int(square[1]) << 2 | int(square[2]) << 1 | int(square[3])
#
#	match index:
#		0, 15:
#			pass
#		1, 14:
#			segments.append([Vector2(0.5, 1), Vector2(1, 0.5)])
#		2, 13:
#			segments.append([Vector2(0, 0.5), Vector2(1, 0.5)])
#		3, 12:
#			segments.append([Vector2(0, 0.5), Vector2(1, 0.5)])
#			segments.append([Vector2(0.5, 1), Vector2(1, 0.5)])
#		4, 11:
#			segments.append([Vector2(0.5, 0), Vector2(1, 0.5)])
#		5, 10:
#			segments.append([Vector2(0.5, 0), Vector2(0.5, 1)])
#		6, 9:
#			segments.append([Vector2(0.5, 0), Vector2(1, 0.5)])
#			segments.append([Vector2(0, 0.5), Vector2(1, 0.5)])
#		7, 8:
#			segments.append([Vector2(0.5, 0), Vector2(0, 0.5)])
#		_, _:
#			assert(false, "Invalid index")
#
#	return segments
#
#func _add_segment_to_contours(contours: Array, segment: Array) -> void:
#	var start = segment[0]
#	var end = segment[1]
#
#	for contour in contours:
#		if contour.back() == start:
#			contour.push_back(end)
#			return
#		elif contour.front() == end:
#			contour.push_front(start)
#			return
#
#	contours.append(segment)

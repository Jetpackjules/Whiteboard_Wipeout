extends Node2D

var draw_data = []

func _ready():
	get_tree().current_scene.connect("update_visuals", self, "_on_update_visuals")
	get_tree().current_scene.connect("update_old_visuals", self, "_on_update_old_visuals")
	
	
func _on_update_visuals(cluster):
	draw_data.clear()

	var viewport_height = get_viewport().size.y

#	for point in stack:
#		draw_data.append({"rect": Rect2(point.x, viewport_height - point.y, 1, 1), "color": Color(1, 0, 0)})
#
	for point in cluster:
		print("green")
		draw_data.append({"rect": Rect2(point.x, viewport_height - point.y-1, 1, 1), "color": Color(0, 1, 0)})

	yield(get_tree(), "idle_frame")  # Add this line
	update()


func _on_update_old_visuals(old_clusters):
	draw_data.clear()
	print("old")
	
	var viewport_height = get_viewport().size.y
	
	for old_cluster in old_clusters:
		for point in old_cluster:
			var pos = point #* 4
			print("red_old")
			draw_data.append({"rect": Rect2(pos.x,viewport_height - pos.y-1, 1, 1), "color": Color(1, 0, 0)})


func _draw():
	for data in draw_data:
		draw_rect(data.rect, data.color)

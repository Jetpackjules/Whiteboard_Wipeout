extends Camera2D
onready var player_cam = get_node("../Kinematic_Player/Player_Cam")
onready var texture_rect = get_node("../TextureRect")
onready var walking_player_cam = get_node("../Walking_Player/Player_Cam")
func _ready():
	pass

func _process(delta):
#	print(texture_rect.rect_size)
#	print(texture_rect.stretch_mode)
#	print(texture_rect.rect_size)
	
	if Input.is_action_pressed("camera_1"):
			print("Main Cam")
			player_cam.current = false
			self.current = true
			
	if Input.is_action_pressed("camera_2"):
			print("CAMERA 2 (Player)")
			player_cam.current = true

	if Input.is_action_pressed("camera_3"):
			print("CAMERA 3 (Player walking)")
			walking_player_cam.current = true



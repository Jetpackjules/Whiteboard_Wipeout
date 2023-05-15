extends KinematicBody2D

# Customize the character's movement speed and jump strength
const MOVE_SPEED = 100
const JUMP_STRENGTH = 600
const GRAVITY = 1200



var vertical_velocity = 0


# Customize the force and torque applied when moving and turning
var move_force = 1500
var turn_torque = 2500


var leg_speed = 1.0



var TargetSpeed = 0
var Speed = 0
 
var Rot = 0
var RotAmount = 0.2
 
onready var RayFront = get_node("RayFront")
onready var RayCenter = get_node("RayCenter")
onready var RayBack = get_node("RayBack")
 
onready var Gismos = get_node("Gismos")
var frame = 0

var LeftPos = Vector2(-16,0)
var LeftKneePos = Vector2(0,0)
var RightPos = Vector2(16,0)
var RightKneePos = Vector2(0,0)
var State = 0

var stride_multiplier = 1
var stride_width = 32
var KeyFrames = [Vector2(stride_width, 0), Vector2(0, 0), Vector2(-stride_width, 0), Vector2(0, -16)]

func get_running_keyframes() -> Array:
	return [
		Vector2(32, 0),
		Vector2(0, 0),
		Vector2(-32, 0),
		Vector2(32, -16)  # Increase the kickback by increasing the negative Y value
	]


 
var LegLenght = 22
var Faceing = 1
 
var RightActual = Vector2()
var RightKneeActual = Vector2()
var LeftActual = Vector2()
var LeftKneeActual = Vector2()
 
func _draw():
	var multi = 0.3
	RightActual.x = lerp(RightActual.x,RightPos.x,multi)
	RightActual.y = lerp(RightActual.y,RightPos.y,multi)
	RightKneeActual.x = lerp(RightKneeActual.x,RightKneePos.x,multi)
	RightKneeActual.y = lerp(RightKneeActual.y,RightKneePos.y,multi)
 
	LeftActual.x = lerp(LeftActual.x,LeftPos.x,multi)
	LeftActual.y = lerp(LeftActual.y,LeftPos.y,multi)
	LeftKneeActual.x = lerp(LeftKneeActual.x,LeftKneePos.x,multi)
	LeftKneeActual.y = lerp(LeftKneeActual.y,LeftKneePos.y,multi)
 
	draw_line(Vector2(0,-32),LeftKneeActual,Color(1,1,1),2)
	draw_line(LeftKneeActual,LeftActual,Color(1,1,0.5),2)
 
	draw_line(Vector2(0,-32),RightKneeActual,Color(0.5,1,1),2)
	draw_line(RightKneeActual,RightActual,Color(1,1,0.5),2)
 
func _ready():
	LeftPos = get_global_position()+Vector2(0,0)
	RightPos = get_global_position()+Vector2(16,0)
 

func _physics_process(delta):

	TargetSpeed = 0
	if Input.is_action_pressed("move_left"):
		TargetSpeed -= MOVE_SPEED
		Faceing = -1
	if Input.is_action_pressed("move_right"):
		TargetSpeed += MOVE_SPEED
		Faceing = 1
	Speed = lerp(Speed, TargetSpeed, 1)
	Rot = 0
	set_rotation(Rot)
	
	vertical_velocity += GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		vertical_velocity = -JUMP_STRENGTH

	var motion = Vector2(Speed, vertical_velocity)
	motion = move_and_slide(motion, Vector2.UP)
	
	if is_on_floor():
		vertical_velocity = 0
	
	frame += 1
	if frame >= 5:
		frame = 0

		State += Speed / 3000  # Increase this value to make the legs move faster
		if State > 1:
			State = 0
		if State < 0:
			State = 1


	FindNewPos(RayFront, 0, get_running_keyframes())
	FindNewPos(RayCenter, 1, get_running_keyframes())
	FindNewPos(RayBack, 2, get_running_keyframes())

	var MyPos = get_global_position()
	var running_keyframes = get_running_keyframes()
	LeftPos = Gismos.BlendKeyframe(running_keyframes, State)
	RightPos = Gismos.BlendKeyframe(running_keyframes, State + 0.5)

	LeftKneePos = UpdateKneePos(Vector2(0, -32), LeftPos, LegLenght)
	RightKneePos = UpdateKneePos(Vector2(0, -32), RightPos, LegLenght)

	update()

func UpdateKneePos(var StartPos, var EndPos, var leglenght):
	var Dir = StartPos.angle_to_point(EndPos)
	var Dis = Gismos.DistanceToPoint(StartPos,EndPos)
	var y = sqrt(clamp((leglenght*leglenght)-(Dis/2 * Dis/2),0,9999))
	var alpha = asin(y/leglenght)
	var knee
	if Faceing == 1: # Facing right
		knee = StartPos + Vector2(leglenght * sin(alpha - Dir - PI / 2) * stride_multiplier, leglenght * cos(alpha - Dir - PI / 2))
	else: # Facing left
		knee = StartPos + Vector2(leglenght * sin(alpha + Dir - PI / 2) * stride_multiplier, leglenght * cos(alpha - Dir - PI / 2))
		
	return(knee)

 


func FindNewPos(ray, arrayindex, keyframes):
	if ray.is_colliding():
		if ray.get_collider().is_in_group("Ground"):
			var collision_point = ray.get_collision_point()
			var collision_normal = ray.get_collision_normal()
			var adjusted_collision_point = collision_point - (collision_normal * 4)
			var keyframe_value = adjusted_collision_point - get_global_position()

			# Scale the stride length
			if arrayindex == 0 or arrayindex == 2:
				keyframe_value.x *= stride_multiplier

			KeyFrames[arrayindex] = adjusted_collision_point - get_global_position() - keyframes[arrayindex]




func reset_character():
		position = Vector2(500, 60) # Change this to your desired respawn position
		vertical_velocity = 0

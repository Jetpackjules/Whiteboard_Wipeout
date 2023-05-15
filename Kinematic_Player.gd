extends KinematicBody2D

export (float) var speed = 200
export (float) var jump_force = -500
export (float) var slide_speed = 100
export (float) var wall_jump_force = -400
export (float) var gravity = 1200
export (float) var wall_friction = 200

var velocity = Vector2()
var on_wall = false
var jumping = false

onready var animated_sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D
var started_moving = false


func _physics_process(delta):
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)
	# Reset character when 'R' is pressed
	if Input.is_action_just_pressed("reset"):
		reset_character()
		started_moving = false

	# Movement
	if direction.x != 0:
		started_moving = true
	velocity.x = direction.x * speed

	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		jumping = true
	
	# Sliding
	if Input.is_action_pressed("slide") and is_on_floor():
		velocity.x = direction.x * slide_speed
		
		
		
	# Wall Jumping
	on_wall = is_on_wall() and not is_on_floor() and not jumping
	if on_wall:
#		print("WALL JUMP!")
		velocity.y = min(velocity.y, wall_friction)
		if Input.is_action_just_pressed("jump"):
			velocity.y = wall_jump_force
			velocity.x = -sign(get_slide_collision(0).normal.x) * abs(wall_jump_force)
			jumping = true


	# Gravity
	if started_moving:
		velocity.y += gravity * delta

	
	# Move character
	velocity = move_and_slide(velocity, Vector2.UP)

	# Reset jumping state
	if is_on_floor():
		jumping = false

	# Update animation
	update_animation()

func update_animation():
	animated_sprite.flip_h = velocity.x < 6
#	print(velocity.y)
	if is_on_floor():
		if Input.is_action_pressed("slide"):
			animated_sprite.play("Slide")
		elif abs(velocity.x) > 10:
			animated_sprite.play("Run_R")
		else:
#			print("iiidle")
			animated_sprite.play("Idle")
	else:
		if on_wall:
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Jump")


func reset_character():
		position = Vector2(500, 20) # Change this to your desired respawn position
		velocity = Vector2.ZERO


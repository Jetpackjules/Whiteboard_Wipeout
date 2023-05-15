extends KinematicBody2D
#
#export (int) var speed = 200
#export (int) var jump_strength = 300
#export (float) var gravity = 800
#
#var velocity = Vector2.ZERO
#
#func _physics_process(delta):
#	# Get player input
#	var move_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
#
#	# Apply horizontal movement
#	velocity.x = move_direction * speed
#
#	# Apply gravity
#	velocity.y += gravity * delta
#
#	# Jump
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = -jump_strength
#
#	# Move character
#	velocity = move_and_slide(velocity, Vector2.UP)
#
#	# Flip the sprite based on movement direction
#	if move_direction != 0:
#		$Sprite.flip_h = move_direction < 0
#
#func _input(event):
#	if event.is_action_pressed("attack"):
#		# Add your attack logic here
#		pass

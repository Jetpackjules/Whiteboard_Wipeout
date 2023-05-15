extends CollisionPolygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var polygon = [Vector2(804, 456), Vector2(803, 456), Vector2(803, 456), Vector2(804, 455), Vector2(804, 455), Vector2(804, 457), Vector2(804, 457), Vector2(803, 455), Vector2(803, 455), Vector2(803, 457), Vector2(803, 457), Vector2(803, 454), Vector2(803, 454), Vector2(804, 458), Vector2(804, 458), Vector2(803, 458), Vector2(803, 458), Vector2(803, 453), Vector2(803, 453), Vector2(803, 459), Vector2(803, 459), Vector2(803, 452), Vector2(803, 452), Vector2(803, 460), Vector2(803, 460), Vector2(803, 451), Vector2(803, 451), Vector2(803, 450), Vector2(803, 450), Vector2(803, 449), Vector2(803, 449), Vector2(803, 448), Vector2(803, 448), Vector2(803, 447), Vector2(803, 447), Vector2(803, 446), Vector2(803, 446), Vector2(803, 445), Vector2(803, 445), Vector2(803, 444), Vector2(803, 444), Vector2(803, 443), Vector2(803, 443), Vector2(803, 442), Vector2(803, 442), Vector2(803, 441), Vector2(803, 441), Vector2(803, 440), Vector2(803, 440), Vector2(803, 439), Vector2(803, 439), Vector2(802, 439), Vector2(802, 439), Vector2(803, 438), Vector2(803, 438), Vector2(802, 438), Vector2(802, 438), Vector2(803, 437), Vector2(803, 437), Vector2(802, 437), Vector2(802, 437), Vector2(803, 436), Vector2(803, 436), Vector2(802, 436), Vector2(802, 436), Vector2(803, 435), Vector2(803, 435), Vector2(802, 435), Vector2(802, 435), Vector2(803, 434), Vector2(803, 434), Vector2(802, 434), Vector2(802, 434), Vector2(803, 433), Vector2(803, 433), Vector2(802, 433), Vector2(802, 433), Vector2(803, 432), Vector2(803, 432), Vector2(802, 432), Vector2(802, 432), Vector2(803, 431), Vector2(803, 431), Vector2(802, 431), Vector2(802, 431), Vector2(803, 430), Vector2(803, 430), Vector2(802, 430), Vector2(802, 430), Vector2(803, 429), Vector2(803, 429), Vector2(802, 429), Vector2(802, 429), Vector2(803, 428), Vector2(803, 428), Vector2(802, 428), Vector2(802, 428), Vector2(803, 427), Vector2(803, 427), Vector2(802, 427), Vector2(802, 427), Vector2(803, 426), Vector2(803, 426), Vector2(802, 426), Vector2(802, 426), Vector2(803, 425), Vector2(803, 425), Vector2(802, 425), Vector2(802, 425), Vector2(803, 424), Vector2(803, 424), Vector2(803, 423), Vector2(803, 423), Vector2(803, 422), Vector2(803, 422), Vector2(803, 421), Vector2(803, 421), Vector2(802, 421), Vector2(802, 421), Vector2(803, 420), Vector2(803, 420), Vector2(802, 420), Vector2(802, 420), Vector2(803, 419), Vector2(803, 419), Vector2(802, 419), Vector2(802, 419), Vector2(803, 418), Vector2(803, 418), Vector2(802, 418), Vector2(802, 418), Vector2(803, 417), Vector2(803, 417), Vector2(802, 417), Vector2(802, 417), Vector2(803, 416), Vector2(803, 416), Vector2(802, 416), Vector2(802, 416), Vector2(803, 415), Vector2(803, 415), Vector2(802, 415), Vector2(802, 415), Vector2(803, 414), Vector2(803, 414), Vector2(802, 414), Vector2(802, 414), Vector2(803, 413), Vector2(803, 413), Vector2(802, 413), Vector2(802, 413), Vector2(803, 412), Vector2(803, 412), Vector2(803, 411), Vector2(803, 411), Vector2(803, 410)]
	set_polygon(polygon)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

class_name Webcam_HTML5
extends Node

# HOW TO USE:
# Right click the drop down on `texture` in the inspector and create a new ImageTexture
export var texture :ImageTexture
# Click the dropdown again and hit "copy", then find the node you want to connect to the webcam paste into that texture
# BIG IMPORTANT NOTES:
# - This will only work on HTML5 exports. I'm using a lot of JS hackery. Maybe one day desktop will be viable.
# - This is fairly brute force, copying images from the browser to Godot via Base64
# 		- That means it's slow, don't try to increase the resolution too much. Unless you just need pictres, not video.
#		- Maybe OneDay I'll figure out how to feed a video stream directly into Godot, but today isn't that day.

#you can pass a PNG or JPEG in. This is a performance vs quality decision.
enum FORMAT {PNG,JPEG}
export(FORMAT) var format = FORMAT.JPEG 

#Only used if `format == FORMAT.JPEG`
export var jpeg_quality:float= 0.2

#Works similar to `Viewport.render_target_update_mode`.
enum UPDATE {ONCE,EVERY_FRAME,NEVER}
export(UPDATE) var update = UPDATE.EVERY_FRAME setget set_update

#If you can make this feature work, let me know. I want to this to work on mobile to use the back camera.
enum FACING {DEFAULT,USER,ENVIRONMENT}
export(FACING) var facing = FACING.DEFAULT

#Don't go over board with this unless you just need the one frame
export var height:int=1080

#these are private and you should not need them
var width = height setget disable_set # this is calculated by height * aspect
var id = -1 setget disable_set # this is used to mess with the dom
var document setget disable_set # dom foothold
var video setget disable_set # video element
var canvas setget disable_set # canvas element


func _init():
	if OS.get_name() == "HTML5":
		id = randi()
		document = JavaScript.get_interface("document")
		video = document.createElement("video");
		canvas = document.createElement("canvas");
		set_up()
	else:
		printerr("WARNING: Webcam_HTML5 will ONLY work on web!")
		update = UPDATE.NEVER

func _enter_tree():
	if OS.get_name() == "HTML5":
		document.body.appendChild(video)
		document.body.appendChild(canvas)

func _exit_tree():
	if OS.get_name() == "HTML5":
		video.remove()
		canvas.remove()

func _process(_delta):
	if update != UPDATE.NEVER:
		update_texture()
		if update == UPDATE.ONCE:
			update = UPDATE.NEVER

func update_texture():
	var img := Image.new()
	match format:
		FORMAT.PNG:
			var p = capture_camera().right(png_prefix.length())
			img.load_png_from_buffer(Marshalls.base64_to_raw(p))
		FORMAT.JPEG:
			var p = capture_camera().right(jpeg_prefix.length())
			img.load_jpg_from_buffer(Marshalls.base64_to_raw(p))

	texture.create_from_image(img)
	return texture









func capture_camera()->String:
	width = height * get_aspect()
	var canvas = document.getElementById(String(id) + "_canvas")
	var video = document.getElementById(String(id) + "_video")
	video.height = height;
	video.width = width;
	canvas.height = height;
	canvas.width = width;
	canvas.getContext('2d').drawImage(video, 0, 0, width, height); 
	var base64:=""
	match format:
		FORMAT.PNG:
			base64 = canvas.toDataURL();
		FORMAT.JPEG:
			base64 = canvas.toDataURL('image/jpeg',jpeg_quality);
	return base64
	
func get_aspect()->float:
	if video.videoHeight != 0:
		return float(video.videoWidth)/float(video.videoHeight)
	else:
		return 1.0

func set_up():
	video.id = String(id) + "_video";
	video.autoplay = "true";
	video.height = height;
	video.width = width;
	set_up_video_element()
	canvas.id = String(id) + "_canvas";
	canvas.height = height;
	canvas.width = width;
	
	video.hidden = true
	canvas.hidden = true

func set_up_video_element():
	var navigator = JavaScript.get_interface("navigator")
	var video_settings = JavaScript.create_object("Object")
	video_settings.video = true
	match facing:
		FACING.ENVIRONMENT:
			video_settings.facingMode = "environment"
		FACING.USER:
			video_settings.facingMode = "user"
		FACING.DEFAULT:
			pass
		_:
			assert(false,"set_up: THIS FACING MODE NOT IMPLEMENTED!")
	if navigator.mediaDevices.getUserMedia:
		navigator.mediaDevices.getUserMedia(video_settings).then(
			_set_stream_callback
		).catch(
			_error_callback
		)

#callback return ARRAYS(!) in GDScript. index[0] is always the first return arg, etc. This is poorly documented.
var _set_stream_callback = JavaScript.create_callback(self,"set_stream") 
func set_stream(stream):
	video.srcObject = stream[0]

var _error_callback = JavaScript.create_callback(self,"error")
func error(err0r):
	JavaScript.get_interface("console").log("SOMETHING WENT WRONG!", err0r)

func set_update(value):
	if OS.get_name() != "HTML5":
		update = UPDATE.NEVER
	else:
		update = value

const png_prefix = "data:image/png;base64,"
const jpeg_prefix = "data:image/jpeg;base64,"

func disable_set(value):
	assert(false,"This var should never be externally set!")

extends Node3D

@onready var camera : Camera3D = get_node("Camera3D")
@onready var backcamera : Camera3D = camera.get_node("BackCamera3D")
@onready var sphere : MeshInstance3D = get_node("Sphere")
@onready var PicturePlayer : TextureRect = sphere.get_node("Player/Picture")
@onready var VideoPlayer : VideoStreamPlayer = sphere.get_node("Player/VideoStreamPlayer")
@onready var PlayerUI : Node3D = get_node("PlayerUI")

var last_x = 0
var last_y = 0

var is_touch_pressed = false

func _ready():
	PlayerUI.player = VideoPlayer

func _process(delta):
	keyboard_controls(delta)
	check_sensor(delta)

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			is_touch_pressed=true
		else:
			is_touch_pressed=false
	
	touch(event)
	mouse(event)

func move_camera(x,y,delta,do_clamp=true):
	camera.rotation.y += x * delta
	camera.rotation.x += y * delta
	if do_clamp:
		camera.rotation.x = clamp(camera.rotation.x,-1.5,1.5)

func show_playerui():
	if !PlayerUI.visible:
		var curcam
		
		if camera.current:
			curcam = camera
		else:
			curcam = backcamera
		
		PlayerUI.rotation = curcam.rotation
	
	PlayerUI.visible = !PlayerUI.visible

func mouse(event):
	if event is InputEventMouseButton and event.double_click:
		show_playerui()
	
	if Input.is_action_just_pressed("mouse_lclick"):
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		last_x = event.position.x
		last_y = event.position.y
	
	if Input.is_action_just_released("mouse_lclick"):
		Input.set_default_cursor_shape()
	
	if Input.is_action_pressed("mouse_lclick"):
		if InputEventMouseMotion:
			var x = (last_x - event.position.x) * .005
			last_x = event.position.x
			var y = (last_y - event.position.y) * .005
			last_y = event.position.y
			move_camera(-x,-y,1)
	
	if Input.is_action_just_pressed("zoom_in"):
		camera.fov -= 1
	
	if Input.is_action_just_pressed("zoom_out"):
		camera.fov += 1

func touch(event):
	if event is InputEventScreenDrag:
		if event.relative.x != 0:
			var x = event.relative.x / 5
			var y = event.relative.y / 5
			move_camera(x,y,.005)
	elif event is InputEventScreenTouch:
		if event.double_tap:
			show_playerui()

func check_sensor(delta):
	if not is_touch_pressed:
		var gyro = Input.get_gyroscope()
		
		if gyro != Vector3.ZERO:
			move_camera(gyro.y, gyro.x, delta, false)

func keyboard_controls(delta):
	#var LEFT = Input.get_action_strength("move_left")
	#var RIGHT = Input.get_action_strength("move_right")
	#var UP = Input.get_action_strength("move_up")
	#var DOWN = Input.get_action_strength("move_down")
	#
	#var x = LEFT + -RIGHT
	#var y = UP + -DOWN
	
	var move = Input.get_vector("move_right","move_left", "move_down","move_up")
	
	if Input.is_action_pressed("zoom_in") and not Input.is_action_just_pressed("zoom_in"):
		camera.fov -= 1
	if Input.is_action_pressed("zoom_out") and not Input.is_action_just_pressed("zoom_out"):
		camera.fov += 1
	
	move_camera(move.x,move.y,delta)

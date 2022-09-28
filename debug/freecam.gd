class_name FreeCam
extends Window

@onready var cam = Camera3D.new()

var controls = [["game_vx+","game_vx-"],["game_vy+","game_vy-"],["game_vz+","game_vz-"]]
var pressed = [[false,false],[false,false],[false,false],false]
var axis_dir = Vector3i(0,0,0)
var speed = 8.0
var sensetivity = 0.008
var cam_up = Vector3(0,1,0).normalized()

# Called when the node enters the scene tree for the first time.
func _ready():
	var mwnd = get_node("/root/Iroot")
	title = "Freecam"
	size = mwnd.size*.5
	position = mwnd.size*.25
	close_requested.connect(_close)
	size_changed.connect(_wresize)
	var t
	t = cam
	add_child(t)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam.position += (GlobalCustom.vec_basis_trensform(axis_dir, cam.basis) * speed * delta)
	pass
	
func _wresize():
	pass

func _close():
	queue_free()

func _input(event):
	#if event is InputEventKey and event.is_pressed():
	if event.is_action_pressed("ui_escape"):
		_close()
	if event.is_action_pressed("game_toggle_mlock"):
		pressed[3] = !pressed[3]
		if pressed[3]:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if pressed[3]:
		if event is InputEventMouseMotion:
			var m = sensetivity * event.relative
			cam.rotate(cam_up,-m.x)
			cam.rotate(cam.basis.x.normalized(),-m.y)
	if event is InputEventScreenDrag:
		pass
	for group in 3:
		for action in 2:
			if event.is_action(controls[group][action]):
				pressed[group][action] = event.pressed
				if event.pressed:
					axis_dir[group] = [1,-1][action]
				else:
					axis_dir[group] = [0,[-1,1][action]][int(pressed[group][[1,0][action]])]

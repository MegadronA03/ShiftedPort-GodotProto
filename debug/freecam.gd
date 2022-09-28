class_name FreeCam
extends Window

@onready var cam = Camera3D.new()

var mouse_lock = false
var axis_dir = Vector3i()
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
	if mouse_lock:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	queue_free()

func _input(event):
	#if event is InputEventKey and event.is_pressed():
	if event.is_action_pressed("ui_escape"):
		_close()
	if event.is_action_pressed("game_toggle_mlock"):
		mouse_lock = !mouse_lock
		if mouse_lock:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if mouse_lock: #should node even bother?
		if event is InputEventMouseMotion: #node should bother checking input
			var m = sensetivity * event.relative
			cam.rotate(cam_up,-m.x)
			cam.rotate(cam.basis.x.normalized(),-m.y)
	if event is InputEventScreenDrag: #controls for touch devices
		pass
	for axis in 3: #update movement direction
		var dir = "xyz"[axis] #0 - x; 1 - y; 2 - z
		axis_dir[axis] = Input.get_action_strength("game_v"+dir+"+") - Input.get_action_strength("game_v"+dir+"-")

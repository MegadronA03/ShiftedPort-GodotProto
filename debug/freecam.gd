class_name FreeCam
extends Window

@onready var cam = Camera3D.new()

var controls = [["game_vx+","game_vx-"],["game_vy+","game_vy-"],["game_vz+","game_vz-"]]
var pressed = [[false,false],[false,false],[false,false]]
var axis_dir = Vector3i(0,0,0)
var speed = 16.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var mwnd = get_node("/root/Iroot")
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
	cam.position += axis_dir * speed * delta
	pass
	
func _wresize():
	pass

func _close():
	queue_free()

func _input(event):
	#if event is InputEventKey and event.is_pressed():
	if event is InputEventAction: #some whaky and cool thing for iterating through binds
		for group in 3:
			for action in 2:
				if event.is_action(controls[group][action]):
					pressed[group][action] = event.pressed
					if event.pressed:
						axis_dir[group] = [1,-1][action] #hehe, tho it still doesnt work
					else:
						axis_dir[group] = [0,[-1,1][action]][int(pressed[group][[1,0][action]])]

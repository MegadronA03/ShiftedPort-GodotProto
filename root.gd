extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	set_name("Iroot")
	var ctrlwnd = Console.new() #TODO: into external container
	ctrlwnd.set_name("wnd")
	add_child(ctrlwnd)
	var t
	var c
	#t = SubViewportContainer.new()
	#t.anchor_top = 0.0
	#t.anchor_left = 0.0
	#t.anchor_bottom = .5
	#t.anchor_right = .5
	#t.stretch = true
	#add_child(t)
	#c = t
	t = Window.new()
	#t.transparent_bg = true
	t.size = floor(size*0.5)
	t.position = size*.25
	#t.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(t)
	c = t
	var w = WorldEnvironment.new()
	c.add_child(w)
	t = Camera3D.new()
	t.keep_aspect = Camera3D.KEEP_WIDTH
	w.add_child(t)
	t = MeshInstance3D.new()
	t.position = Vector3(-.75, -.75, -3.)
	t.mesh = PlaneMesh.new()
	w.add_child(t)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

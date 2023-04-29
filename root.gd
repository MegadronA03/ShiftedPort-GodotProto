class_name GStart
extends Control
#@onready
var test_scene = preload("res://game/scenes/origins_test.tscn")
@onready var rootW = $"/root"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_name("Iroot")
	var t
	#var c
	#print_debug(DisplayServer.screen_get_dpi())
	rootW.content_scale_factor = 96.0/DisplayServer.screen_get_dpi()
	if OS.has_feature("mobile"): #if mobile (should be used for enabeling touch controls)
		#https://docs.godotengine.org/en/latest/tutorials/inputs/inputevent.htmls
		#https://docs.godotengine.org/en/latest/classes/class_inputeventscreentouch.html
		#top left conner drag to open console
		#$"/root".size = Vector2i(256,256)
		
		#TODO: add these as setting to change
		rootW.scaling_3d_scale = 0.25
		#rootW.content_scale_factor = 3.0
		var l = Console.new()
		add_child(l)
	else:
		pass
		#rootW.content_scale_factor = 1.0
		#rootW.content_scale_aspect = 1.0
		#rootW.content_scale_mode = rootW.CONTENT_SCALE_MODE_DISABLED
		#rootW.content_scale_mode = rootW.CONTENT_SCALE_MODE_CANVAS_ITEMS
		#rootW.content_scale_size = Vector2(1280.0,720.0)
	
	t = test_scene.instantiate()
	add_child(t)
	#var w = WorldEnvironment.new()
	#add_child(w)
	#t = Camera3D.new()
	#t.keep_aspect = Camera3D.KEEP_WIDTH
	#w.add_child(t)
	#t = MeshInstance3D.new()
	#t.position = Vector3(-.75, -.75, -3.)
	#t.mesh = PlaneMesh.new()
	#w.add_child(t)
	
	#t = SubViewportContainer.new()
	#t.anchor_top = 0.0
	#t.anchor_left = 0.0
	#t.anchor_bottom = .5
	#t.anchor_right = .5
	#t.stretch = true
	#add_child(t)
	#c = t
	
	#t = Window.new()
	#t.transparent_bg = true
	#t.size = floor(size*0.5)
	#t.position = size*0.25
	#t.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	#add_child(t)
	#c = t
	#t = Camera3D.new()
	#t.keep_aspect = Camera3D.KEEP_WIDTH
	#c.add_child(t)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	#if event is InputEventKey and event.is_pressed():
	if event.is_action_pressed("toggle_console"): #`
		var ctrlwnd = Console.new()
		add_child(ctrlwnd)

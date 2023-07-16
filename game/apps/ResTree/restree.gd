class_name ResTree
extends Window

var inode
var layout = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# get_script_property_list
	title = "ResTree: " + str(inode.name)
	var mwnd = get_parent()
	size = mwnd.size*.5
	position = mwnd.size*.25
	
	var t
	t = Panel.new()
	layout.body = t
	t.anchor_top = 0.0
	t.anchor_left = 0.0
	t.anchor_bottom = 1.0
	t.anchor_right = 1.0
	add_child(t)
	var t1 = t
	
	t = VBoxContainer.new()
	layout.bodycontainer = t
	t.anchor_top = 0.0
	t.anchor_left = 0.0
	t.anchor_bottom = 1.0
	t.anchor_right = 1.0
	t1.add_child(t)
	t1 = t
	
	t = Panel.new()
	layout.head = t
	t.custom_minimum_size = Vector2(32.0, 32.0)
	t1.add_child(t)
	var t2 = t
	
	t = HBoxContainer.new()
	layout.headcontainer = t
	t.custom_minimum_size = Vector2(32.0, 32.0)
	t2.add_child(t)
	t2 = t
	
	t = Button.new()
	layout.backbtn = t
	t.text = "../"
	t.custom_minimum_size = Vector2(32.0, 32.0)
	t2.add_child(t)
	
	t = Button.new()
	layout.cmdhbtn = t
	t.text = ">_"
	t.custom_minimum_size = Vector2(32.0, 32.0)
	t.pressed.connect(_openconsole)
	t2.add_child(t)
	
	t = Button.new()
	layout.updbtn = t
	t.text = "refresh"
	t.custom_minimum_size = Vector2(32.0, 32.0)
	t.pressed.connect(_refresh)
	t2.add_child(t)
	
	t = Button.new()
	layout.homebtn = t
	t.text = "home"
	t.custom_minimum_size = Vector2(32.0, 32.0)
	t.pressed.connect(_toroot)
	t2.add_child(t)
	
	t = Button.new()
	layout.homebtn = t
	t.text = "duplic"
	t.custom_minimum_size = Vector2(32.0, 32.0)
	t.pressed.connect(_duplic)
	t2.add_child(t)
	
	t = TabContainer.new()
	layout.content = t
	#t.dragger_visibility = SplitContainer.DRAGGER_VISIBLE
	#t.split_offset = size.x*0.5
	t.size_flags_vertical = t.SIZE_EXPAND_FILL
	t.custom_minimum_size = Vector2(32.0, 32.0)
	t1.add_child(t)
	t1 = t
	
	t = VBoxContainer.new()
	layout.contentC = t
	t.set_name("Children")
	t1.add_child(t)
	t2 = t
	
	
	t = VBoxContainer.new()
	layout.contentP = t
	t.set_name("Properties")
	t1.add_child(t)
	t2 = t
	
	
	t = VBoxContainer.new()
	layout.contentF = t
	t.set_name("Procedures")
	t1.add_child(t)
	t2 = t
	
	_refresh()
	
	close_requested.connect(_close)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _init(node):
	inode = node
	pass

func _refresh():
	var l = layout.contentC
	for item in l.get_children():
		item.queue_free()
	for child in inode.get_children():
		var t = Button.new() #Placeholders
		t.text = str(child.get_class()," ",child.name)
		l.add_child(t)
	l = layout.contentP
	var pl = get_property_list()
	#for key in pl:
	#	value = 
	l = layout.contentF
	pass

func _toroot():
	pass

func _duplic():
	get_node("/root/Iroot").add_child(new(inode))
	pass

func _toparent():
	var p = inode.get_parent()
	if (p):
		inode = p
		_refresh()
	pass

func _openconsole():
	var r = get_node("/root/Iroot")
	r.add_child(Console.new(inode))
	pass

func _close():
	queue_free()
	pass

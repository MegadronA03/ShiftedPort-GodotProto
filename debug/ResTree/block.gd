extends Panel

var peekswt
var fcont
var inode
var content = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#var margin = MarginContainer.new()
	anchor_top = 0.0
	anchor_left = 0.0
	anchor_bottom = 1.0
	anchor_right = 1.0
	grow_vertical = true
	#custom_minimum_size = Vector2(32.0, 32.0)
	size_flags_horizontal = SIZE_EXPAND_FILL
	#var head = HBoxContainer.new()
	#head.grow_horizontal = true
	#head.grow_vertical = true
	#add_child(head)
	#peekswt = CheckButton.new()
	#peekswt.toggled.connect(_expand)
	#head.add_child(peekswt)
	var nn = RichTextLabel.new()
	nn.text = inode.name
	nn.grow_horizontal = true
	nn.grow_vertical = true
	nn.anchor_top = 0.0
	nn.anchor_left = 0.0
	nn.anchor_bottom = 0.0
	nn.anchor_right = 1.0
	nn.custom_minimum_size = Vector2(32.0, 32.0)
	#nn.size_flags_horizontal = SIZE_EXPAND_FILL
	add_child(nn)
	fcont = HBoxContainer.new()
	fcont.offset_top = 32.0
	fcont.anchor_top = 0.0
	fcont.anchor_left = 0.0
	fcont.anchor_bottom = 1.0
	fcont.anchor_right = 1.0
	#fcont.add_theme_constant_override("hseperation", 4)
	add_child(fcont)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _expand(arg):
	if arg:
		for child in inode.get_children():
			var b = get_node("/root/Iroot").rtblock.new()
			b.inode = child
			fcont.add_child(b)
			content.append(b)
		queue_redraw()
	else:
		for _i in content:
			_i.queue_free()
		content = []
		queue_redraw()
	pass

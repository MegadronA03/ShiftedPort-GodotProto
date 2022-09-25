extends Control
const conscript = preload("res://debug/console.gd")
const rtblock = preload("res://debug/ResTree/block.gd")
const Gviewport = preload("res://Gviewport.gd")
const resscript = preload("res://debug/ResTree/restree.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_name("Iroot")
	var ctrlwnd = conscript.new() #TODO: into external container
	ctrlwnd.set_name("wnd")
	add_child(ctrlwnd)
	#var Gviewport = Viewport.new()
	#add_child(Gviewport)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

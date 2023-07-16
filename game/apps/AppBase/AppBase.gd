class_name AppBase #abstract
extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if self is AppBase:
		print_debug("error: trying to start AppBase, terminating...")
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

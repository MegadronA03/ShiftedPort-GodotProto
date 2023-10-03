extends Node
#Env

class HardwareInfo:
	pass

class ThreadOverhead:
	var threads := ArrayMapped.new()
	var threads_active :int= 0

class Benchmarks:
	func thread_alloc():
		pass
	func compute_shader_overhead():
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

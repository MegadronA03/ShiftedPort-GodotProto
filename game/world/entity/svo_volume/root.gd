class_name VolumeRoot
extends Node3D

const voxel_min_size : float = 1.0
var base_size : int = 8 #should be only in base of 2
var topL_size : Vector3i = Vector3i(1,1,1)
var bodies : Array
var parts : Array
var depth : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_real_size():
	return base_size*topL_size

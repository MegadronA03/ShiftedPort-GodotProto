class_name TileChunck3D
extends Node3D

#TODO: its a mess, should be rewritten

var palette := PackedInt32Array()
var neighbours := [self,null,null,null,null,null,null,null].resize(8)
const buffdim = Vector3i(8,4,8) #that should be constant
var buffer := PackedInt32Array() #256 size should be constant
var meshdata := []
#TODO: move RenderingDevice and compute shaders to world.gd class,
# so this wont take unreasonable ammount of space

func update_mesh():
	pass

func update():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

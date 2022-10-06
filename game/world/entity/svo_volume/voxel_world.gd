class_name VoxelWorld
extends Node3D

@onready var triobj = TriangData.new()

var settings : Dictionary = {
	performance = {
		transparency_threshold = 0.975,
		mesh_lod_mul = 1
	}
}

var base_materials : Array = [
	"void"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

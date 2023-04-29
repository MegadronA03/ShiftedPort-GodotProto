extends Node3D
#genearal node for splitting world with bodies into chunks

const meshgen_csh := [ #compute shaders for generating meshes
	#preload("res://game/world/tile/fully_threaded.glsl"),
	#preload("res://game/world/tile/parial_theaded.glsl")
	preload("res://game/world/tile/test.glsl")
]
var meshgen_cbc := [PackedByteArray()] # compiled shaders
#if compiled shader wont work across multiple rendering devices, then move 
# shader compilation to cluster.gd  

@export var VoxelPalette : Dictionary

#@onready var Body : Tree #depriciated, better to check content through children



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass

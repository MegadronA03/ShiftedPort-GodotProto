class_name TileCluster3D
extends PhysicsBody3D

#part of rigid body
#TODO: determine where should be chunk redering and collinsion handeling

@export var gen_model : RDShaderFile
@export var model : PackedInt32Array
@export var palette : PackedInt32Array

#@onready var Body : Tree #depriciated, better to check content through children
@onready var depth : int #inverted counter of tree depth for each node
#but I think its better to calculate it
@onready var visual : bool #is this cluster does rendering
@onready var lod : int #if it is, then what lod is it 

@onready var rigid_root := false #just check children
@onready var hitbox : Area3D

func update():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass

func _init():
	pass

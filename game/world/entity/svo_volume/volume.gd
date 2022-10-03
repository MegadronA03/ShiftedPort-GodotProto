class_name Volume
extends Node3D

var parts = [null,null,null,null,null,null,null,null]
@onready var _mesh : MeshInstance3D = MeshInstance3D.new()
@onready var simbody
@onready var colbody : CollisionShape3D = CollisionShape3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_mesh():
	pass

func split_up():
	for part in parts:
		part = Volume.new()
		part.scale = Vector3(0.5,0.5,0.5)
		part.size = Vector3(1.0,1.0,1.0)
		add_child(part)
	pass

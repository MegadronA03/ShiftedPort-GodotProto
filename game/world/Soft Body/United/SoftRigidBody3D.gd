class_name SoftRigidBody3D
extends RigidBody3D

const TetrahShape = preload("res://game/world/Soft Body/UnitTetrahedron.tscn")

@export var mesh_shell : ArrayMesh #visual representation
@export var point := {
	"position" : PackedVector3Array(),
	"velocity" : PackedVector3Array(),
	"force" : PackedVector3Array(),
	"mass" : PackedFloat32Array(),
	"locked" : PackedInt32Array() # used to lock
}

#palette with cached springs properities,
# pulled from material properity palette. memo:(temperature, stress, strain)
var springs : PackedVector3Array #array with springs (pi0, pi1, properities)
var spring_prop := {
	"stiffness" : PackedFloat32Array(),
	"damping_f" : PackedFloat32Array(),
	"drag_f" : PackedFloat32Array(),
	"rest_length" : PackedFloat32Array(),
	"rest_dislocation" : PackedFloat32Array(),
} 

@onready var parts : Array # shape shifting convex collision shapes

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_integrator = false
	#self.mass = sum of FEM masses
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass # shape deforming 

func _update_mesh():
	pass # shape splitting, gluing

func _integrate_forces(state):
	#Euler integration
	pass

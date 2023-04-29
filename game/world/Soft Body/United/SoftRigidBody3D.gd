class_name SoftRigidBody3D
extends RigidBody3D

@export var mesh : Mesh
@onready var parts : Array # shape shifting convex collision shapes

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_integrator = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass # shapeshifting call

func _integrate_forces(state):
	pass

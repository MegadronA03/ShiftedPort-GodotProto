class_name SoftTthdrl3D
extends RigidBody3D

const unit_ttrhdrn = preload("res://game/world/Soft Body/UnitTetrahedron.tres")
@onready var collider := CollisionShape3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(collider)
	collider.shape = unit_ttrhdrn
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass

func _integrate_forces(state):
	pass

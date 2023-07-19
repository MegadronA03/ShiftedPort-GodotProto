extends CollisionShape3D

#const unit_ttrhdrn = preload("res://game/world/Soft Body/UnitTetrahedron.tres")
@onready var neighbours := [null,null,null,null]
@onready var vert_ind : PackedInt32Array = [0,0,0,0]
const d6 := 1.0/6.0
var volume := 0

func update_volume():
	volume = d6 * abs(basis.x.dot(basis.y.cross(basis.z)))

func get_volume():
	return volume

# Called when the node enters the scene tree for the first time.
func _ready():
	#shape = unit_ttrhdrn
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass

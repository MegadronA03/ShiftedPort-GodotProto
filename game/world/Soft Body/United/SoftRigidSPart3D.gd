extends CollisionShape3D

#const unit_ttrhdrn = preload("res://game/world/Soft Body/UnitTetrahedron.tres")
@onready var neighbours := [null,null,null,null]
@onready var vert_ind : PackedInt32Array = [0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	#shape = unit_ttrhdrn
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass

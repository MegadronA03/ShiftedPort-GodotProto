extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func vec_basis_trensform(vec, basis):
	var new_vec = Vector3(0,0,0)
	for d in 3:
		new_vec += basis[d]*vec[d]
	return new_vec

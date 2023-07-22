class_name VolumetricSoftBody3D
extends RigidBody3D

const TetrahShape = preload("res://game/world/Soft Body/UnitTetrahedron.tscn")
@onready var meshinst := $MeshInstance3D
@onready var vtm := [] #data used to construnt volumetric tetrahedral mesh 
@onready var itr := PackedVector3Array() #mesh indicies
@onready var beh := [] #behaivour
@onready var mat := [] #materials
@onready var col := [] #collisions (they also store neighbours and tetrahedra, material indicies)
var volume := 0.0

@export var mesh_shell : ArrayMesh #visual representation
@export var verticies := {
	"position" : PackedVector3Array(),
	"velocity" : PackedVector3Array(),
	"force" : PackedVector3Array(),
	"mass" : PackedFloat32Array(),
	"locked" : PackedInt32Array() # used to lock
}

#palette with cached springs properities,
# pulled from material properity palette. memo:(temperature, stress, strain)
var springs := {
	"indicies" : PackedVector2Array(),
	"stiffness" : PackedFloat32Array(),
	"damping_f" : PackedFloat32Array(),
	"drag_f" : PackedFloat32Array(),
	"rest_length" : PackedFloat32Array(),
	"rest_dislocation" : PackedFloat32Array(),
}



@onready var parts : Array # shape shifting convex collision shapes

func add_tetrahedra(verts,material_index):
	var ind := PackedInt32Array([0,0,0,0])
	for i in 4:
		if len(verts[i]) == 2:
			var t = verts[i]
			while 1:
				pass
			
		else:
			verticies.position.append(Vector3(verts[i]))
			ind[i] = len(verticies.position)
	var o = TetrahShape.instantiate()
	add_child(o)
	col.append(o)

func _init(vtmn : Array, matn : Array):
	if (vtmn == null) || (vtmn == []):
		push_warning("SoftRigidBody3D: no model was found!")
		queue_free()
		return
	if (matn == null) || (matn == []):
		push_warning("SoftRigidBody3D: no materials provided!")
		#
		#col = [o]
		#telm = [[o,[null,null,null,null]]]
	vtm = vtmn.duplicate()
	
	for i in vtmn:
		match len(i):
			3:#from face
				if len(i[2]) == 3:
					pass
					#add_tetrahedra([,i[2]],i[0])
					#verticies.position.append(Vector3(i[4]))
			4:#origin
				add_tetrahedra([[0,0,0],i[1],i[2],i[3]],i[0])
			5:#new from verts
				add_tetrahedra([i[1],i[2],i[3],i[4]],i[0])

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_integrator = false
	#self.mass = sum of FEM masses
	pass

func update_volume():
	var volsum = 0.0
	if true:#len(cols) < 64:
		var workers = []
		var mutex = Mutex.new()
		var vol_call = func(c):
			mutex.lock()
			volsum += c.get_volume()
			mutex.unlock()
		for i in range(len(workers)):
			workers[i] = Thread.new()
			workers[i].start(vol_call.bind(col[i]))
		for i in workers:
			i.wait_to_finish()
	else:
		for i in col: # TODO: parallel it on GPU
			volsum += i.get_volume()
	volume = volsum
	#return volsum
	
func get_volume():
	return volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass # shape deforming 

func update_mesh():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	#surface_array[Mesh.ARRAY_VERTEX] = verts
	#surface_array[Mesh.ARRAY_TEX_UV] = uvs
	#surface_array[Mesh.ARRAY_NORMAL] = normals
	#surface_array[Mesh.ARRAY_INDEX] = indices
	
	#meshinst.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	update_volume() #TODO: it shuoldn't be there
	pass # shape splitting, gluing

func _integrate_forces(state):
	#Euler integration
	pass

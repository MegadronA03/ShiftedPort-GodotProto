extends Resource
class_name VolTetMesh

var collision : ConcavePolygonShape3D
var visible_mesh : ArrayMesh # Array mesh with computed visible surfaces
@export var materials : Array = []
@export var tet_instr : Array = [] # store data on how to constuct mesh form tets
var tetmesh_verts : PackedVector3Array # verts of tetrahedrons (do not use in visible_mesh)
var tet_inds : PackedInt32Array # used for storing tetrahedrons indicies
var tet_neigh : Array = [] # used generate visible faces
var tet_mats : PackedInt32Array = []
var unpacked := false
var volume : float
const tet_faces := [[1,3,2],[2,3,0],[3,1,0],[0,2,1]]

# return 4 verts of tetrahedron
func get_tet_verts(tet_id : int) -> PackedVector3Array:
	return PackedVector3Array([
		tetmesh_verts[tet_inds[tet_id<<2]],
		tetmesh_verts[tet_inds[tet_id<<2+1]],
		tetmesh_verts[tet_inds[tet_id<<2+2]],
		tetmesh_verts[tet_inds[tet_id<<2+3]]])

# return 3 indicies of tetrahedron that forms its face
func get_tet_face_ind(tet_id : int,excuded_vert : int) -> PackedInt32Array:
	return PackedInt32Array([
		tetmesh_verts[tet_inds[tet_id<<2+tet_faces[excuded_vert][0]]],
		tetmesh_verts[tet_inds[tet_id<<2+tet_faces[excuded_vert][1]]],
		tetmesh_verts[tet_inds[tet_id<<2+tet_faces[excuded_vert][2]]]])

# used with data from get_tet_verts() and returns verticies of tet face
func get_tet_face(tet_v : PackedVector3Array, excluded_vert : int) -> PackedVector3Array:
	return PackedVector3Array([
		tet_v[tet_faces[excluded_vert][0]],
		tet_v[tet_faces[excluded_vert][1]],
		tet_v[tet_faces[excluded_vert][2]]])

func get_tet_material(tet_id:int) -> int:
	return tet_mats[tet_id]

func add_free(verts : Array, mat : int) -> void:
	pass

# add first tet to the tet array
func add_origin(verts3 : PackedVector3Array, mat ) -> void:
	pass

func add_from_face(tet_id, face_id, vert, mat = null) -> void:
	pass

func remove_tet(tet_id:int):
	pass

func place_tet(instruction : Array, mat : int = 0, new_mat : bool = false) -> void:
	match len(instruction):
		2: # from face
			var sm = null
			if new_mat:
				sm = mat
			add_from_face(instruction[0][0],instruction[0][1],instruction[1],mat)
		3: # origin
			add_origin(instruction,mat)
		4: # full tetrahedron
			add_free(instruction,mat)
		_:
			print_stack()
			push_error("place_tet: failed to parse the instruction:" + str(instruction))
	pass

#load array from parsed json
func load_tmi(tmi : Array):
	var ver = tmi[0][0]
	match ver:
		0:
			var matb := 0
			var ti = tmi[1]
			for i in len(ti):
				var mt = ti[i]
				if mt.has(1):
					matb = mt[1]
					place_tet(mt[0],matb,true)
				else:
					place_tet(mt[0],matb)
#				if mt.has(1):
#					matb = mt[1]
#				else:
#					if len(mt[0] == 2):
#						matb = get_tet_material(mt[0])
				
		_:
			print_stack()
			push_error("load_tmi: unknown version of imported mesh: "+str(ver))

#get array for saving in json
func get_tmi() -> Array:
	return tet_instr # placeholder
	pass

func unpack(): # used to generate tetrahedrons
	pass

func repack(): # used to generate instructions if initial mesh was changed
	pass

func get_mesh():
	pass

func get_collision_concave():
	pass

func get_collision_convex_tet():
	pass

func get_collision_convex_tet_grouped():
	pass

func cut(shape,type) -> void:
	match (shape.get_class()):
		"Plane":
			plane_cut(shape,type)
		"Mesh":
			mesh_cut(shape,type)
		"VolTetMesh":
			tetmesh_cut(shape,type)
		_:
			print_stack()
			push_error("cut(): not supported shape type: " + shape.get_class())
	pass

func plane_cut(plane : Plane, type) -> void: # cuts mesh using plane
	
	pass

func mesh_cut(mesh : Mesh, type) -> void: # cuts mesh using other mesh intersection
	pass

func tetmesh_cut(tetmesh : VolTetMesh, type) -> void: # cuts mesh using other tetmesh intersection
	pass

func merge(tetm0 : VolTetMesh, tetm1 : VolTetMesh) -> void: # merge 2 meshes
	pass

func update_volume():
	pass

extends Resource
class_name VolTetMesh

var collision : ConcavePolygonShape3D
var visible_mesh : ArrayMesh # Array mesh with computed visible surfaces
@export var materials : Array = []
@export var tet_instr : Array = [] # store data on how to constuct mesh form tets
var tetmesh_verts : PackedVector3Array # verts of tetrahedrons (do not use in visible_mesh)
#var tetmesh_cache : PackedByteArray # cache for faster tetrahedron manipulation
var tetmesh_
var tetrahedrons := ArrayMapped.new(Array(range(64)))
var unpacked := false
var volume : float
const tet_faces := [[1,3,2],[2,3,0],[3,1,0],[0,2,1]]

class VolTetUnit:
	var indicies : PackedInt32Array = [-1,-1,-1,-1]
	var neighbours : Array = [null,null,null,null]
	var material_id : int
	const tet_faces := [[1,3,2],[2,3,0],[3,1,0],[0,2,1]]
	# return 3 indicies of tetrahedron that forms its face
	func get_face(excuded_vert : int) -> PackedInt32Array:
		return PackedInt32Array([
			indicies[tet_faces[excuded_vert][0]],
			indicies[tet_faces[excuded_vert][1]],
			indicies[tet_faces[excuded_vert][2]]])
	func _init(indicies):
		
		pass
	func plane_cut(p:Plane):
		pass

class VolTetVert:
	var v : Vector3 # vertex
	var ts := ArrayMapped.new(PackedInt32Array([])) # tetrahedrons with that vert

# free up the space using defragmentation
# might not be used if each vertex gonna have references to tetrahedrons
func cleanup_tetverts():
	var ta := tetrahedrons.get_data_array()
	var tmv := PackedVector3Array()
	tmv.resize(tetmesh_verts.size())
	for t in ta:
		pass
	pass

# return 4 verts of tetrahedron
func get_tet_verts(tet : VolTetUnit) -> PackedVector3Array:
	return PackedVector3Array([
		tetmesh_verts[tet.indicies[0]],
		tetmesh_verts[tet.indicies[1]],
		tetmesh_verts[tet.indicies[2]],
		tetmesh_verts[tet.indicies[3]]])

# used with data from get_tet_verts() and returns verticies of tet face
func get_tet_face(tet_v : PackedVector3Array, excluded_vert : int) -> PackedVector3Array:
	return PackedVector3Array([
		tet_v[tet_faces[excluded_vert][0]],
		tet_v[tet_faces[excluded_vert][1]],
		tet_v[tet_faces[excluded_vert][2]]])

func get_tet_material(tet:VolTetUnit):
	return materials[tet.material_id]

func add_free(verts : Array, mat : int) -> void:
	for i in 4:
		match len(verts[i]):
			2:
				pass
			3:
				pass

# add first tet to the tet array
func add_origin(verts3 : PackedVector3Array, mat ) -> void:
	
	pass

func add_from_face(tet_id, face_id, vert, mat) -> void:
	
	pass

func remove_tet(tet_id:int):
	tetrahedrons.remove_at(tet_id)
	pass

func place_tet(instruction : Array, mat : int = 0, new_mat : bool = false) -> void:
	match len(instruction):
		2: # from face
			var sm = null
			if new_mat:
				sm = mat
			add_from_face(instruction[0][0],instruction[0][1],instruction[1],sm)
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
					if len(mt[0] == 2): # hacky fix, may be changed
						matb = tetrahedrons[mt[0][0][0]].material_id
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


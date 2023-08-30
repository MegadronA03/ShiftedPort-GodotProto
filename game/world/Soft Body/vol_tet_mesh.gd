extends Resource
class_name VolTetMesh

var collision : ConcavePolygonShape3D
var visible_mesh : ArrayMesh # Array mesh with computed visible surfaces
@export var materials : Array = []
@export var tet_instr : Array = [] # store data on how to constuct mesh form tets
var tetmesh_verts : PackedVector3Array # verts of tetrahedrons (do not use in visible_mesh)
#var tetmesh_cache : PackedByteArray # cache for faster tetrahedron manipulation
var tetmesh := ArrayMapped.new()
var tetrahedrons := ArrayMapped.new()
var unpacked := false
var volume : float
const tet_faces := [[1,3,2],[2,3,0],[3,1,0],[0,2,1]]

class VolTetUnit:
	var indicies : PackedInt32Array = [-1,-1,-1,-1]
	var neighbours : PackedInt32Array = [-1,-1,-1,-1]
	var material_id : int
	var self_id : int
	const tet_faces := [[1,3,2],[2,3,0],[3,1,0],[0,2,1]]
	# return 3 indicies of tetrahedron that forms its face
	func get_face(excuded_vert : int) -> PackedInt32Array:
		return PackedInt32Array([
			indicies[tet_faces[excuded_vert][0]],
			indicies[tet_faces[excuded_vert][1]],
			indicies[tet_faces[excuded_vert][2]]])
	func _init(indicies=null):
		
		pass
	func plane_cut(p:Plane):
		pass

class VolTetVert:
	var vert : Vector3 # vertex
	# TODO: implement custom structure with fast item adding in sorted order (like binary search tree)
	var tets := ArrayMapped.new(PackedInt32Array([])) # tetrahedrons with that vert
	func _init(v = null):
		match typeof(v):
			TYPE_VECTOR3,TYPE_VECTOR3I:
				vert = v as Vector3
			12,13,20,28,29,30,31,32,33: # arrays and other types
				vert = Vector3(v[0],v[1],v[2])

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

# used to get face from one tet locally
func get_tet_face_elements(tet_v : Array, excluded_vert : int) -> Array:
	return Array([
		tet_v[tet_faces[excluded_vert][0]],
		tet_v[tet_faces[excluded_vert][1]],
		tet_v[tet_faces[excluded_vert][2]]])

func get_tet_material(tet:VolTetUnit):
	return materials[tet.material_id]

# TODO: get side id from indicies
func get_tet_ev():
	pass

# TODO: tetrahderon neighbour link
func link_tet_neighbours(tet0:VolTetUnit,ev0:int,tet1:VolTetUnit,ev1:int=-1) -> void:
	pass

func find_side_neigh(tet : VolTetUnit, vtas : Array, vis : PackedInt32Array):
	# do a little sorting for order checking without useless reads
	var voc : PackedByteArray = [0,1,2]
	if vtas[0].size > vtas[1].size:
		voc = [1,0,2]
	if vtas[voc[1]].size > vtas[2].size:
		voc = [1,2,voc[1]]
	if vtas[voc[0]].size > vtas[voc[1]].size:
		voc = [voc[1],voc[0],voc[2]]
	
	for ti0 in vtas[voc[0]].get_data_array():
		# TODO: pick ti0 tetrahedra and start checking its sides
		tetrahedrons.databuff[ti0]
		# comparing 3 indicies across list is inefficient
		#for ti1 in vtas[voc[1]].get_data_array():
		#	if ti0 == ti1:
		#		for ti2 in vtas[voc[2]].get_data_array():
		#			if ti0 == ti2:
		#				
		#				return # return neighbour ID and his side

func update_side_neigh(tet : VolTetUnit, vtas : Array, ev : int, n = null) -> void:
	if n == null:
		n = find_side_neigh(tet,get_tet_face_elements(vtas,ev))
	link_tet_neighbours(tet,ev,n[0],n[1]) # TODO: think about on what side linking gonna happen

func update_tet_neighs(tet : VolTetUnit, vtas : Array, neighs : Array = [null,null,null,null]) -> void:
	pass

func add_free(verts : Array, mat : int, neighs : PackedInt32Array = [-1,-1,-1,-1]) -> void:
	var tet := VolTetUnit.new()
	var tet_id := tetrahedrons.alloc_val(tet)
	tet.self_id = tet_id
	var vtas : Array = [null,null,null,null] # holds vector tetrahedron arrays
	#var iv :int = 0 # indexed vectors
	var lev :int = -1 # last excluded vector (-1 NOTHING, -2 MORE_THAN_2)
	for i in 4:
		match len(verts[i]):
			2:
				tet.indicies[i] = tetrahedrons.databuff[verts[i][0]].indicies[verts[i][1]]
				#iv |= 1<<i
			3:
				var ind := tetmesh.alloc_val(VolTetVert.new(verts[i]))
				tet.indicies[i] = ind
				match lev:
					-1:
						lev = i # probably will need real vert id
					-2:
						pass
					_:
						lev = -2
		vtas[i] = tetmesh.databuff[tet.indicies[i]].tets # adding objects to a list for later use
	# TODO : face linking (tet.neighbours)
	# for reference see get_tet_face(vtas,ev)
	# were replaces with direct array construction to skip function calls
	# needs benchmarking, if const tet_faces changed, use lines with get_tet_face
	match lev:
		-1:
			update_tet_neighs(tet,vtas,neighs)
		-2:
			pass
		_:
			update_side_neigh(tet,vtas,lev,neighs[lev])
	#match (iv): # invert this
	#	7:	# 0111 	[1,3,2]
	#		update_side_neigh(tet,vtas,0,neighs[0])
	#	11:	# 1011	[2,3,0]
	#		update_side_neigh(tet,vtas,1,neighs[1])
	#	13:	# 1101	[3,1,0]
	#		update_side_neigh(tet,vtas,2,neighs[2])
	#	14:	# 1110	[0,2,1]
	#		update_side_neigh(tet,vtas,3,neighs[3])
	#	15:	# 1111
	#		update_tet_neighs(tet,vtas,neighs)
	for i in 4: # add tet to verts after neigh check to skip self checks
		vtas[i].alloc_val(tet_id)

# add first tet to the tet array
func add_origin(verts3 : PackedVector3Array, mat : int ) -> void:
	
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
			tetrahedrons.resize(ti.size())
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


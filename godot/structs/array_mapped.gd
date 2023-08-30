#interface class for all arrays
#used for internal memory allocation
extends Object
class_name ArrayMapped

var databuff
var mempbuff : PackedInt32Array
var size : int
var alloc_size : int

func _init(buffbody = null):
	match typeof(buffbody):
		28,29,30,31,32,33,34,35,36,37: # arrays and packed arrays
			databuff = buffbody
			mempbuff.resize(buffbody.size())

#func _get_property_list():
#	var pl : Dictionary = a._get_property_list()
#	pl.merge(_get_property_list())
#	return pl

# if object freed, use this to check that
# warning: freed space may be occupied later,
#  that means there might be different data that you won't expect
#  so please erase references and dont use this
func is_ind_valid(index:int):
	if (index < size):
		return mempbuff[index] == index
	else:
		return mempbuff[index] < 0

# finish if performance is impacted
#func push_end():
#	mempbuff.push_back(0)
#	if databuff:
#		match typeof(databuff):
#			databuff.push_back(null)

# of internal use because it doesn't check anything
func resize_nc(s:int):
	mempbuff.resize(s)
	if databuff:
		databuff.resize(s)

func resize(s:int):
	if s < alloc_size:
		print_stack()
		push_warning("ArrayMapped: Trying to free occupied space! expect to see glitches!")
	resize_nc(s)

# implement if performance issues were encountered
#func free_unused_tail():
#	resize(alloc_size)

func _remove_at_b0(I:int) -> void: # do not use: internal block
	if size == I:
		mempbuff[I] = 0
	else:
		mempbuff[I] = mempbuff[size]
		if mempbuff[size] == size:
			mempbuff[size] = -1-I
		else:
			mempbuff[size] = 0
			mempbuff[mempbuff[I]] = -1-I 

func remove_at(index:int) -> void:
	size -= 1
	#var IO := index
	var I : int
	if size < index:
		I = -1-mempbuff[index]
		_remove_at_b0(I)
		mempbuff[index] = 0
	else:
		I = index
		_remove_at_b0(I)
	var sas = alloc_size-1
	if index == (sas):
		while (mempbuff[sas-1] != 0) && (sas-1 >= size):
			sas -= 1
		alloc_size = sas
		resize_nc(sas)

func alloc() -> int:
	if alloc_size == size:
		#resize(mempscach<<1)
		# docs says that adding/removing on end is fast
		# but didnt specify if push_back or resize is better for that case
		resize_nc(alloc_size+1) 
	var outp : int
	var lel := mempbuff[size]
	if lel == 0:
		outp = size
	else:
		outp = -1-lel
		mempbuff[outp] = outp
	mempbuff[size] = size
	size += 1
	alloc_size = max(size, alloc_size)
	return outp

# will return error if no databuff in place
func alloc_val(value) -> int:
	var a := alloc()
	databuff[a] = value
	return a

# TODO: add sorted variants
func get_data_array(data = databuff) -> Array:
	var nd : Array = []
	nd.resize(size)
	for i in size:
		nd[i] = data[mempbuff[i]]
	return nd

func get_data_func(data:Callable) -> Array:
	var nd : Array = []
	nd.resize(size)
	for i in size:
		nd[i] = data.call(mempbuff[i])
	return nd

# TODO : this can be mutithreaded
func integrity_test() -> Vector3i:
	if size < 0:
		return Vector3i(1,0,0) # size should not be negative
	var MaxIndex := alloc_size
	for i in size:
		var e := mempbuff[i]
		if e != i:
			if e < size:
				return Vector3i(2,i,e) # invalid forward ptr
			else:
				var ee := mempbuff[e]
				if ee > 0:
					return Vector3i(3,i,e) # invalid backward ptr
				else:
					if ee != 0:
						if (-1-ee) == i:
							MaxIndex = max(MaxIndex,e)
						else:
							return Vector3i(4,i,e) # broken link
	for i in range(size,mempbuff.size()):
		var e := mempbuff[i]
		if e != 0:
			if (-1-e) < size:
				return Vector3i(5,i,e) # invalid backward ptr
			else:
				var ee := mempbuff[-1-e]
				if ee != i:
					return Vector3i(6,i,e) # broken link, probably found garbage
	return Vector3i(0,0,0) # OK

# TODO : make it prettier
func integrity_error() -> void:
	var err := integrity_test()
	match (err.x):
		1:
			push_error("ArrayMapped: size should not be negative")
		2:
			push_error("ArrayMapped:on index:"+str(err.y)+" invalid forward pointer:"+str(err.z)+".")
		3:
			push_error("ArrayMapped:on index:"+str(err.y)+" invalid backward pointer:"+str(err.z)+".")
		4:
			push_error("ArrayMapped:on index:"+str(err.y)+" broken link:"+str(err.z)+".")
		5:
			push_warning("ArrayMapped:on index:"+str(err.y)+" invalid backward pointer:"+str(err.z)+". Probably found garbage.")
		6:
			push_warning("ArrayMapped: on index:"+str(err.y)+" broken link:"+str(err.z)+". Probably found garbage.")
#func get_array_ordered(): # TODO
#	pass

#func defragmentate():
#	pass

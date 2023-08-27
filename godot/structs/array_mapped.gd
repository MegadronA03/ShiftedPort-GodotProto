#interface class for all arrays
extends Object
class_name ArrayMapped

var databuff
var mempbuff : PackedInt32Array
var size

func _init(buffbody = null):
	match typeof(databuff):
		28,29,30,31,32,33,34,35,36,37: # arrays and packed arrays
			databuff = buffbody

#func _get_property_list():
#	var pl : Dictionary = a._get_property_list()
#	pl.merge(_get_property_list())
#	return pl

func _remove_at_b0(I:int) -> void: # do not use: interlan block
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
	var IO := index
	var I : int
	if size < index:
		I = -1-mempbuff[IO]
		_remove_at_b0(I)
		mempbuff[IO] = 0
	else:
		I = index
		_remove_at_b0(I)

func new_element(value):
	var outp : int
	var lel := mempbuff[size]
	if lel == 0:
		outp = size
	else:
		outp = -1-lel
		mempbuff[outp] = outp
	mempbuff[size] = size
	size += 1
	return outp

#func push_array(arr):
#	pass

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

# if object was freed, use this to check that
# warning: freed space may be occupied later
func is_ind_valid(index:int):
	if (index < size):
		return mempbuff[index] == index
	else:
		return mempbuff[index] < 0

func integrity_test():
	pass

#func get_array_ordered(): # TODO
#	pass

#func defragmentate():
#	pass

#func _get(properity): # overrride functions
#	pass

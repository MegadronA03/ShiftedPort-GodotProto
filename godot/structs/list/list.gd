extends Object
class_name List
# simple leist that doesnt keep track of its size
var next : List
var prev : List
var value
func _init(value):
	value = value
func seek(rel_i:int,size:int=0):
	if rel_i == 0:
		return self
	if size != 0:
		rel_i = fmod(rel_i,size)
		var back_rel = 1-size+rel_i
		if rel_i > abs(back_rel):
			# TODO: needs testing
			rel_i = back_rel
	var p := self
	if sign(rel_i) < 0:
		for i in abs(rel_i):
			p = p.prev
	else:
		for i in abs(rel_i):
			p = p.next
	return p
func insert(list:List,lenend):
	pass
func split(lenend):
	pass
func remove(): # for secure and fast deletion please delete content in "value" first
	next.prev = prev
	prev.next = next
	free()
func remove_seq(lenend):
	pass
func destroy(): # removes entire list
	pass
func filter(test:Callable):
	pass
func filter_split(test:Callable):
	pass
func all(exec:Callable):
	pass
func get_size() -> int:
	var p := next
	var size := 1
	while (self != p):
		p = p.next
		size += 1
	return size
func get_array(lenend = null) -> Array:
	var arr := []
	if lenend == null:
		var p := next
		arr.append(self)
		while (self != p):
			arr.append(p)
			p = p.next
	elif lenend is List: # warning: may hung if it doesnt exist
		var p := next
		arr.append(self)
		while (self != p) && (lenend != p):
			arr.append(p)
			p = p.next
		if (self != p):
			print_stack()
			push_error("List: no such element exist in this chain")
	else:
		if lenend == 0:
			return []
		var p := self
		if sign(lenend) < 0:
			for i in abs(lenend):
				arr.append(self)
				p = p.prev
		else:
			for i in abs(lenend):
				arr.append(self)
				p = p.next
	return arr
func has(indob) -> List: # TODO: add reverse search
	var p := next
	var sind := 0
	while (self != p) && (sind < indob):
		p = p.next
		sind += 1
	if (sind == indob):
		return p
	else:
		return null
func push_next(value) -> List:
	var n := next
	next = List.new(value)
	next.next = n
	next.prev = self
	n.prev = next
	return next
func push_prev(value):
	var p := prev
	prev = List.new(value)
	prev.prev = p
	prev.next = self
	p.next = prev
	return prev

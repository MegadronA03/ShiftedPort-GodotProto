extends Object
class_name List

var next : List
var prev : List
var value
func _init(value):
	value = value
func seek(rel_i:int):
	if rel_i == 0:
		return self
	var p := self
	if sign(rel_i) < 0:
		for i in abs(rel_i):
			p = p.prev
	else:
		for i in abs(rel_i):
			p = p.next
	return p
func insert(list:List,length):
	pass
func split(length):
	pass
func remove(): # for secure and fast deletion please delete content in "value" first
	next.prev = prev
	prev.next = next
	free()
func remove_seq(length):
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
func has(index):
	pass
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

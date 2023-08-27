extends Object
class_name ListHeader

var size : int = 0
var entry : List
func get_value(property):
	get_item(property).value
func get_item(index):
	if index is int:
		var outp := entry
		if index == 0:
			return outp
		if sign(index) == -1:
			for i in abs(index):
				outp = outp.prev
		else:
			for i in abs(index):
				outp = outp.next
		return outp
	else:
		return null

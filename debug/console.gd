extends Window

enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT
}

var type_tostr = [
	"int",
	"str",
	"bool",
	"float"
]

var command_history = []
var commandhistoryline = 0

var content
var input
var expression = Expression.new()
var inode

var commands = {
	#console functions
"restree": [func(args):
	var inst = inode
	if !(args.size() < 1):
		inst = get_node(args[0])
	if (is_instance_valid(inst)):
		var r = get_node("/root/Iroot")
		var rwnd = r.resscript.new(inst) #TODO: into external container
		r.add_child(rwnd)
		return "OK"
	else:
		return "[color=red]ERROR: No such instance found[/color]"
,[ARG_STRING]],
"clr": [func(args):
	content.clear()
,[]],
"help": [func(args):
	for i in commands:
		if (commands[i][1] != []):
			var argstr = []
			for e in commands[i][1]:
				argstr.append("<"+type_tostr[e]+">")
			output_text(str(i," "," ".join(argstr)))
		else:
			output_text(str(i))
		#output_text(str(i,argstr))
,[]],
"version": [func(args):
	var export_config = ConfigFile.new()
	export_config.load("res://export_presets.cfg")
	output_text(str("[color=cyan]", export_config.get_value("preset.0.options", 'application/product_version'), "[/color]"))
,[]],
"run_as": [func(args):
	var inst = inode
	if !(args.size() < 1):
		inst = get_node(args[0])
	if (is_instance_valid(inst)):
		title = "Console: " + inst.get_class() + " " + str(inst.name)
		return "OK"
	else:
		return "[color=red]ERROR: No such instance found[/color]"
,[ARG_STRING]],
"echo": [func(args):
	if !(args.size() < 1):
		return str(args[0])
,[ARG_STRING]]
}

func check_type(string, type):
	if type == ARG_INT:
		return string.is_valid_integer()
	if type == ARG_FLOAT:
		return string.is_valid_float()
	if type == ARG_STRING:
		return true
	if type == ARG_BOOL:
		return (string == "true" or string == "false")
	return false

func output_text(txt):
	if txt == null:
		return
	content.append_text(txt + "\n")

func goto_command_history(offset):
	commandhistoryline += offset
	commandhistoryline = clamp(commandhistoryline, 0, command_history.size())
	if commandhistoryline < command_history.size() and command_history.size() > 0:
		input.text = command_history[commandhistoryline]

func add_comand(name_, fn, args): #fn - function(not name), args - array
	commands[name_] = [fn,args]

func print_usage(cmd):#TODO: integrate
	var cmd_info = commands[cmd]
	var args_fmt = " "
	for i in cmd_info[1]:
		args_fmt += "<" + type_tostr[i] + "> "
	return str("Usage: ", cmd, args_fmt)


func process_command(text):#TODO: integrate
	command_history.append(text)
	commandhistoryline = command_history.size()
	
	if text[0] != "/":
		var error = expression.parse(text, [])
		if error != OK:
			output_text("[color=red]COMPILE ERROR: "+expression.get_error_text()+"[/color]")
			print(expression.get_error_text())
			return
		var result = expression.execute([], inode, true)
		if expression.has_execute_failed():
			output_text("[color=red]ERROR: "+expression.get_error_text()+"[/color]")
		else:
			output_text(str(result))
		return
	
	var words = text.split(" ")
	words = Array(words)
	
	if words.size() == 0:
		return
	
	for i in range(words.count("")):
		words.erase("")
	
	var command_word = words.pop_front()
	
	command_word = command_word.substr(1)
	
	if !(command_word in commands):
		output_text("[color=red]COMMAND ERROR: Unknown command[/color]")
		return
	
	var cmd_info = commands[command_word]
	if words.size() != cmd_info[1].size():
		output_text("[color=orange]WARNING: Arguments doesnt match![/color]")
		output_text("[color=green]"+print_usage(command_word)+"[/color]")
	for i in range(cmd_info[1].size()):
		if (words.size() > i):
			if not check_type(words[i], cmd_info[1][i]):
				output_text(print_usage(command_word))
				break
		else:
			break
	output_text(cmd_info[0].call(words))

func _init(node = null):
	if (node != null):
		inode = node

# Called when the node enters the scene tree for the first time.
func _ready():
	if (!inode):
		inode = get_tree().get_root()
	title = "Console: " + inode.get_class() + " " + str(inode.name)
	var mwnd = get_node("/root/Iroot")
	transparent_bg = true
	transparent = true
	size = mwnd.size*.5
	position = mwnd.size*.25
	close_requested.connect(_close)
	
	var body = Panel.new()
	body.anchor_top = 0.0
	body.anchor_left = 0.0
	body.anchor_bottom = 1.0
	body.anchor_right = 1.0
	add_child(body)
	
	var bodyc = VBoxContainer.new()
	bodyc.anchor_top = 0.0
	bodyc.anchor_left = 0.0
	bodyc.anchor_bottom = 1.0
	bodyc.anchor_right = 1.0
	body.add_child(bodyc)
	
	content = RichTextLabel.new()
	content.size_flags_vertical = content.SIZE_EXPAND_FILL
	content.selection_enabled = true
	content.scroll_following = true
	content.bbcode_enabled = true
	content.context_menu_enabled = true
	bodyc.add_child(content)
	
	input = LineEdit.new()
	bodyc.add_child(input)
	input.text_submitted.connect(_execscr)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _execscr(txt): #TODO: temporary code, should be refactored
	input.clear()
	#command_history.append(txt)
	#commandhistoryline = command_history.size()
	output_text(str("[color=gray]] ", txt, "[/color]"))
	process_command(txt)
	#var is_cmd = (txt[0] == "/")
	#if is_cmd:
	#	var txtp = txt.substr(1)
	#	if (txtp in commands):
	#		commands[txtp][0].call()
	#	else:
	#		output_text("[color=orange]Unknown command[/color]")
	#else:
	#	var error = expression.parse(txt, [])
	#	if error != OK:
	#		print(expression.get_error_text())
	#		return
	#	var result = expression.execute([], inode, true)
	#	if expression.has_execute_failed():
	#		output_text("[color=red]ERROR: "+expression.get_error_text()+"[/color]")
	#	else:
	#		output_text(str(result)+"\n")


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_UP:
			goto_command_history(-1)
		if event.keycode == KEY_DOWN:
			goto_command_history(1)

func _close():
	queue_free()

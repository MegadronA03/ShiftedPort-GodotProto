class_name Console
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
		var rwnd = ResTree.new(inst) #TODO: into external container
		r.add_child(rwnd)
		return "OK"
	else:
		return "[color=red]ERROR: No such instance found[/color]"
,[ARG_STRING]],
"clr": [func(args):
	content.clear()
,[]],
"version": [func(args):
	var export_config = ConfigFile.new()
	export_config.load("res://export_presets.cfg")
	return str("[color=cyan]", export_config.get_value("preset.0.options", 'application/product_version'), "[/color]")
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
,[ARG_STRING]],
"freecam": [func(args):
	var r = get_node("/root/Iroot")
	var t = FreeCam.new()
	r.add_child(t)
,[]],
"help" : []
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
	if text == "":
		return
	
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
	commands["help"] = [func(args):
		for i in commands:
			if (commands[i][1] != []):
				var argstr = []
				for e in commands[i][1]:
					argstr.append("<"+type_tostr[e]+">")
				output_text(str(i," "," ".join(argstr)))
			else:
				output_text(str(i))
			#output_text(str(i,argstr))
	,[]]
	if (node != null):
		inode = node

# Called when the node enters the scene tree for the first time.
func _ready():
	if (!inode):
		inode = get_tree().get_root()
	title = "Console: " + inode.get_class() + " " + str(inode.name)
	var mwnd = get_node("/root/Iroot")
	#transparent_bg = true
	#transparent = true
	size = mwnd.size*.5
	position = mwnd.size*.25
	close_requested.connect(_close)
	
	var t
	
	t = Panel.new()
	var body = t
	t.anchor_top = 0.0
	t.anchor_left = 0.0
	t.anchor_bottom = 1.0
	t.anchor_right = 1.0
	add_child(t)
	
	t = VBoxContainer.new()
	var bodyc = t
	t.anchor_top = 0.0
	t.anchor_left = 0.0
	t.anchor_bottom = 1.0
	t.anchor_right = 1.0
	body.add_child(t)
	
	t = RichTextLabel.new()
	content = t
	t.size_flags_vertical = t.SIZE_EXPAND_FILL
	t.selection_enabled = true
	t.scroll_following = true
	t.bbcode_enabled = true
	t.context_menu_enabled = true
	bodyc.add_child(t)
	
	t = LineEdit.new()
	input = t
	t.text_submitted.connect(_execscr)
	bodyc.add_child(t)
	t.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _execscr(txt): #TODO: temporary code, should be refactored
	input.clear()
	output_text(str("[color=gray]] ", txt, "[/color]"))
	process_command(txt)


func _input(event):
	if event.is_action_pressed("ui_escape"):
		_close()
	if event.is_action_pressed("ui_down"):
		goto_command_history(1)
	if event.is_action_pressed("ui_up"):
		goto_command_history(-1)

func _close():
	queue_free()

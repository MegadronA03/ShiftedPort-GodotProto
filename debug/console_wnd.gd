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

var run_as = null

var command_history = []
var commandhistoryline = 0

var commands = {}

var expression = Expression.new()

func goto_command_history(offset):
	commandhistoryline += offset
	commandhistoryline = clamp(commandhistoryline, 0, command_history.size())
	if commandhistoryline < command_history.size() and command_history.size() > 0:
		%input.text = command_history[commandhistoryline]

func add_comand(name_, fn, args):
	commands[name_] = {"fn": fn, "args": args}

func print_usage(cmd):
	var cmd_info = commands[cmd]
	var args_fmt = " "
	for i in cmd_info["args"]:
		args_fmt += "<" + type_tostr[i] + "> "
	return str("Usage: ", cmd, args_fmt)

func open_restree():
	var rwnd = get_node("../root/Iroot").resscript.new(get_node("../root/Iroot")) #TODO: into external container
	rwnd.set_name("rwnd")
	get_node("../root/Iroot").add_child(rwnd)


func help():
	return "\n".join(commands.keys())


func get_version():
	var export_config = ConfigFile.new()
	export_config.load("res://export_presets.cfg")
	return export_config.get_value("preset.0.options", 'application/product_version')


func process_command(text):
	var words = text.split(" ")
	words = Array(words)
	
	for i in range(words.count("")):
		words.erase("")
	
	if words.size() == 0:
		return
	
	command_history.append(text)
	
	var command_word = words.pop_front()
	
	if command_word[0] != "/":
		var error = expression.parse(text, [])
		if error != OK:
			print(expression.get_error_text())
			return
		var result = expression.execute([], run_as, true)
		if expression.has_execute_failed():
			output_text("[color=red]ERROR: "+expression.get_error_text()+"[/color]")
		else:
			output_text(str(result)+"\n")
		return
	
	command_word = command_word.substr(1)
	
	var cmd_info = commands.get(command_word)
	if cmd_info == null:
		output_text("[color=orange]Unknown command[/color]")
		return
	
	if words.size() != cmd_info.args.size():
		output_text(print_usage(command_word))
		return
	for i in range(words.size()):
		if not check_type(words[i], cmd_info.args[i]):
			output_text(print_usage(command_word))
			return
	output_text(callv(command_word, words))
	pass

func output_text(txt):
	if txt == null:
		return
	%content.append_text(txt + "\n")
	pass


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
	pass


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_UP:
			goto_command_history(-1)
		if event.keycode == KEY_DOWN:
			goto_command_history(1)
	pass

func _init(inst = null):
	run_as = inst
	pass

func _ready():
	close_requested.connect(_close)
	
	add_comand("restree", "open_restree", [])
	add_comand("help", "help", [])
	add_comand("build", "get_version", [])
	
	output_text(str("ShiftedPort ver [color=cyan]", get_version(), "[/color]"))
	pass


func _process(delta):
	pass

func _close():
	queue_free()
	pass


func _on_input_text_submitted(new_text):
	%input.clear()
	output_text(str("[color=gray]] ", new_text, "[/color]"))
	process_command(new_text)
	pass

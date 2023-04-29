class_name GDShellCommandDB
extends RefCounted
@icon("res://addons/gdshell/icon.png")


var _commands: Dictionary = {}
var _aliases: Dictionary = {}


func add_command(path: String) -> bool:
	var name_and_auto_aliases: Dictionary = get_command_name_and_auto_aliases(path)
	if name_and_auto_aliases.is_empty():
		return false
	_commands[name_and_auto_aliases["name"]] = path
	_aliases.merge(name_and_auto_aliases["aliases"], true)
	return true


func add_commands_in_directory(path: String, recursive: bool=true) -> void:
	for command in get_command_file_paths_in_directory(path, recursive):
		add_command(command)


func remove_command(command_name: String) -> bool:
	return _commands.erase(command_name)


func get_command_path(command_name: String) -> String:
	return _commands.get(command_name, "")


func get_all_command_names() -> Array[String]:
	return _commands.keys()


func add_alias(alias: String, command: String) -> bool:
	# This prevents the stupidest cyclic dependency, but the aliases can still be locked into a cycle
	# TODO: Somehow detect the cyclic alias/command dependency and return an error?
	if alias == command:
		return false
	_aliases[alias] = command
	return true


func remove_alias(alias: String) -> bool:
	return _aliases.erase(alias)


func get_all_aliases() -> Dictionary:
	return _aliases.duplicate()


static func get_file_paths_in_directory(path: String, recursive: bool=true) -> Array[String]:
	var paths: Array[String] = []
	var dir: DirAccess = DirAccess.open(path)
	if dir != null:
		dir.list_dir_begin()
		path = dir.get_next()
		while path:
			if dir.current_is_dir():
				if recursive:
					paths += get_file_paths_in_directory(dir.get_current_dir().path_join(path), true)
			else:
				paths.append(dir.get_current_dir().path_join(path))
			path = dir.get_next()
		dir.list_dir_end()
	if paths.is_empty():
		push_warning("[GDShell] No commands found in directory. Check the'GDShellCommandDB.get_file_paths_from_directory() argument'")
	return paths


static func get_command_file_paths_in_directory(path: String, recursive: bool=true) -> Array[String]:
	return get_file_paths_in_directory(path, recursive).filter(func(x): return is_file_gdshell_command(x))


static func is_file_gdshell_command(path: String) -> bool:
	var res: Resource = ResourceLoader.load(path, "GDScript")
	if not res is GDScript:
		return false
	
	var script: Object = (res as GDScript).new()
	if not script is GDShellCommand:
		return false
	
	return true


static func get_command_name_and_auto_aliases(path: String) -> Dictionary:
	var out: Dictionary = {"name": "", "aliases": []}
	var res: Resource = ResourceLoader.load(path, "GDScript")
	if not res is GDScript:
		return out
	
	var script: Object = (res as GDScript).new()
	if not script is GDShellCommand:
		return out
	
	out["name"] = (script as GDShellCommand).COMMAND_NAME
	out["aliases"] = (script as GDShellCommand).COMMAND_AUTO_ALIASES
	return out

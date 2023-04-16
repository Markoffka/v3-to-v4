extends Node
class_name Converter

@export var dictionary: Dictionary
const DICTIONARY_SECTION = "DICTIONARY"
@export_file('*.ini') var file = "replaces.ini"

signal on_finish_prepare()
signal on_start_prepare()
signal on_start_convert()
signal on_finish_convert(output: String)
signal on_error(error: String)

func _get_file(file: String) -> String:
	return OS.get_executable_path().get_base_dir().path_join(file)

func _convert(input: String):
	on_start_convert.emit()
	var output = input
	for key in dictionary:
		output = output.replace(key, dictionary.get(key))
	on_finish_convert.emit(output)

### PREPARE DICTIONARY
func _prepare():
	print_debug('Preparing dictionary...')
	
	on_start_prepare.emit()
	dictionary.clear()
	var external_dictionary = ConfigFile.new()
	
	print_debug('Dictionary found')
	var path_to_file = _get_file(file)
	print(path_to_file)
	external_dictionary.load(path_to_file)
	
	if not external_dictionary.has_section(DICTIONARY_SECTION): 
		print_debug("Dictionary not found")
		on_error.emit("Dictionary not found")
		return
		
	var keys = external_dictionary.get_section_keys(DICTIONARY_SECTION)
	
	if keys.size() < 1:
		on_error.emit("Dictionary dont have keys")
		print_debug("Dictionary dont have keys")
		return
	
	print_debug('Start iterating dictionary')
	
	for key in keys:
		dictionary[key] = external_dictionary.get_value(DICTIONARY_SECTION, key)
		
	print_debug('Dictionary iterated and prepared')
	on_finish_prepare.emit()

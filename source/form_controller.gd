extends Node
class_name FormController

@onready var status = $Control/MarginContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer/Label
@onready var button = $Control/MarginContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer/Button
@onready var input_text = $Control/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/input_text
@onready var output_text = $Control/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/output_text
@export var converter: Converter

func _ready():
	if not converter: push_error('No converter')
	button.pressed.connect(_convert)
	status.text = "wait for input"
	converter.on_finish_convert.connect(on_converter_finished)
	converter.on_finish_convert.connect(on_converter_started)
	converter.on_start_prepare.connect(on_converter_start_prepare)
	converter.on_finish_prepare.connect(on_converter_finish_prepare)
	converter.on_error.connect(on_converter_error)
	converter._prepare()
	
	
func _convert():
	if input_text.text.length() < 1:
		throw_fail('No text for converting')
		return
	status.text = "converting..."
	converter._convert(input_text.text)
	pass

func throw_fail(text: String) -> void:
	pass

func on_converter_finished(output: String) -> void:
	status.text = "finished"
	button.disabled = false
	output_text.text = output

func on_converter_started() -> void:
	status.text = "Start converting..."
	button.disabled = true
	pass

func on_converter_start_prepare() -> void:
	status.text = "Prepare dictionary, wait"
	button.disabled = true
	pass
	
func on_converter_finish_prepare() -> void:
	status.text = "Dictionary prepared, wait converting..."
	button.disabled = false
	pass

func on_converter_error(error: String) -> void:
	status.text = error
	button.disabled = true

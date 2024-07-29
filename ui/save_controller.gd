extends Node

class_name SaveController

@export var save_button: Button
@export var save_file_dialog: FileDialog

@export var open_button: Button
@export var open_file_dialog: FileDialog

signal on_save_requested(path: String)
signal on_open_requested(path: String)

func _ready():
	save_file_dialog.file_selected.connect(on_save_file_selected)
	open_file_dialog.file_selected.connect(on_open_file_selected)
	save_button.pressed.connect(on_save_button_pressed)
	open_button.pressed.connect(on_open_button_pressed)
	
func on_save_file_selected(path: String):
	on_save_requested.emit(path)

func on_open_file_selected(path: String):
	on_open_requested.emit(path)

func on_save_button_pressed():
	save_file_dialog.visible = true

func on_open_button_pressed():
	open_file_dialog.visible = true

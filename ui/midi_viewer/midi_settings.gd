extends Control

class_name MidiSettings

@export var midi_speed_input_box: LineEdit
@export var file_dialog: FileDialog
@export var set_midi_button: Button
@export var generate_notes_button: Button

signal on_generate_notes_requested

# Called when the node enters the scene tree for the first time.
func _ready():
	midi_speed_input_box.text_submitted.connect(on_float_input_box_updated)
	file_dialog.file_selected.connect(on_file_selected)
	set_midi_button.pressed.connect(on_set_button_pressed)
	generate_notes_button.pressed.connect(on_generate_button_pressed)
	
	update()

func update():
	midi_speed_input_box.text = str(GlobalManager.midi_speed)
	
func on_set_button_pressed():
	file_dialog.visible = true

func on_generate_button_pressed():
	on_generate_notes_requested.emit()
	
func on_file_selected(path: String):
	GlobalManager.midi_file_path = path
	SignalManager.on_midi_set.emit()

func on_float_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_float():
		# Usually, info boxes calls the connected item, but they're 1-to-1 so I set it here like this. 
		GlobalManager.midi_speed = float(midi_speed_input_box.text)
		SignalManager.on_midi_viewer_needs_update.emit()
	else:
		update()

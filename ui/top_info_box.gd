extends Node

class_name TopInfoBox

var note: Note

@export var name_label: Label
@export var start_time_input_box: LineEdit
@export var end_time_input_box: LineEdit
@export var size_input_box: LineEdit
@export var delete_button: Button

func _ready():
	start_time_input_box.text_submitted.connect(on_float_input_box_updated)
	end_time_input_box.text_submitted.connect(on_float_input_box_updated)
	size_input_box.text_submitted.connect(on_float_input_box_updated)
	delete_button.pressed.connect(on_delete_button_pressed)
	
func initialize(_note: Note):
	note = _note
	note.on_top_ui_needs_update.connect(update)
	update()

func update():
	name_label.text = note.name
	start_time_input_box.text = str(note.start_time)
	end_time_input_box.text = str(note.start_time + note.end_event.start_time)
	size_input_box.text = str(note.note_size)

func on_float_input_box_updated(new_string: String):
	if new_string.is_valid_float():
		load_info_to_note()
	else:
		update()

# Called when the info box is updated
func load_info_to_note() -> void:
	note.load_info_from_info_box(self)
	

func on_delete_button_pressed():
	note.delete()
	SignalManager.on_note_selected.emit(null)
	#queue_free()

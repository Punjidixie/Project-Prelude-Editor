extends Node

class_name TopInfoBox

var note: Note

@export var name_label: Label
@export var time_input_box: LineEdit

func _ready():
	time_input_box.text_submitted.connect(on_time_input_box_updated)
	
func initialize(_note: Note):
	note = _note
	update()

func update():
	name_label.text = note.name
	time_input_box.text = str(note.start_time)

func on_time_input_box_updated(new_string: String):
	if new_string.is_valid_float():
		load_info_to_note()
	else:
		update()

# Called when the info box is updated
func load_info_to_note() -> void:
	note.load_info_from_info_box(self)

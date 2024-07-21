extends CustomPlayAreaObject

class_name MidiNoteObject

var midi_time: float
var note: int
var note_name: String

@export var button: Button
@export var info_tooltip: Control
@export var tooltip_label: Label

func _ready():
	button.pressed.connect(on_pressed)
	info_tooltip.visible = false
	
func initialize_references(_reference_control: Control, _scale_vector: Vector2):
	reference_control = _reference_control
	scale_vector = _scale_vector

func initialize_midi_info(raw_midi_note):
	note = raw_midi_note.note_number
	midi_time = raw_midi_note.midi_time
	note_name = raw_midi_note.note_name
	tooltip_label.text = "Note: %s\nTime: %.2f" % [note_name, midi_time / 1000.0]
	
func on_pressed():
	info_tooltip.visible = true
	SignalManager.on_midi_note_selected.emit(self)

# Called from the viewer (if is the currently selected one)
func unselect():
	info_tooltip.visible = false


	


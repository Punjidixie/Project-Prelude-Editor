extends CustomPlayAreaObject

class_name MidiNoteObject

var midi_time: float
var note: int

func initialize_references(_reference_control: Control, _scale_vector: Vector2):
	reference_control = _reference_control
	scale_vector = _scale_vector

func initialize_midi_info(pitch: int, time: float):
	note = pitch
	midi_time = time
	


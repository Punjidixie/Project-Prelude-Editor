extends Control

class_name MidiViewer

@export var midi_note_origin: CustomPlayAreaObject
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_time_auto_updated.connect(on_time_updated)
	SignalManager.on_time_manual_updated.connect(on_time_updated)
	spawn_midi_note_objects()
	update_midi_note_objects()

func spawn_midi_note_objects():
	var raw_midi_notes = MidiUtils.process_midi("res://assets/midi/Four_Little_Kittens.mid")
	for raw_midi_note in raw_midi_notes:
		var midi_note_object: MidiNoteObject = ScenePreloader.midi_note_object.instantiate()
		midi_note_object.initialize_references(self, Vector2(88, 100))
		midi_note_object.initialize_midi_info(raw_midi_note.x, raw_midi_note.y)
		midi_note_origin.add_child(midi_note_object)

# If the scale changes, the positions need to change.
func update_midi_note_objects():
	print(midi_note_origin.get_children().size())
	for midi_note_object: MidiNoteObject in midi_note_origin.get_children():		
		var time = midi_note_object.midi_time / 1000
		var y_position = GlobalManager.midi_speed * time
		var x_position = midi_note_object.note - 21 # A0 = 21, C8 = 108
		midi_note_object.set_play_position(Vector2(x_position, y_position))
		

func on_time_updated():
	var delta_pos = GlobalManager.midi_speed * GlobalManager.current_time
	midi_note_origin.set_play_position(Vector2(0, -100 - delta_pos))

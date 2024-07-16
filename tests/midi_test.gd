extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	process_midi()
	pass # Replace with function body.


func process_midi():
	var ms_per_tick = 60000.0 / (120 * 480)
	var parser = MidiFileParser.load_file("res://assets/midi/Four_Little_Kittens.mid")
	var midi_notes = []
	for track in parser.tracks:
		var t: float = 0
		var last_note_t = 0
		for i in range(track.events.size()):
			var event = track.events[i]
			t += event.delta_ticks * ms_per_tick
			if event.event_type == MidiFileParser.Event.EventType.META && event.type == MidiFileParser.Meta.Type.SET_TEMPO:
				# tempo update
				ms_per_tick = event.ms_per_tick
				#print("tempo now " +str(event.bpm)+ " bpm")
			if event.event_type == event.EventType.MIDI && event.note_name != '' && event.velocity > 0:
				last_note_t = t
				midi_notes.append(event.param1)

	print(midi_notes.size())
	print(midi_notes[1])

			

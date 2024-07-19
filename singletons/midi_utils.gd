extends Node


func process_midi(file_name: String) -> Array:
	var ms_per_tick = 60000.0 / (120 * 480)
	var parser = MidiFileParser.load_file(file_name)
	var midi_notes = []
	for track in parser.tracks:
		var t: float = 0
		for i in range(track.events.size()):
			var event = track.events[i]
			t += event.delta_ticks * ms_per_tick
			if event.event_type == MidiFileParser.Event.EventType.META && event.type == MidiFileParser.Meta.Type.SET_TEMPO:
				# tempo update
				ms_per_tick = event.ms_per_tick
				#print("tempo now " +str(event.bpm)+ " bpm")
			if event.event_type == event.EventType.MIDI && event.note_name != '' && event.velocity > 0:
				midi_notes.append(RawMidiNote.instantiate_from_event(event, t))

	return midi_notes

class RawMidiNote:
	var note_number: int
	var midi_time: float
	var note_name: String
	
	static func instantiate_from_event(midi_event, t: float) -> RawMidiNote:
		var instance = RawMidiNote.new()
		instance.note_number = midi_event.param1
		instance.midi_time = t
		instance.note_name = midi_event.note_name
		return instance
		
		

extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func process_midi():
	var ms_per_tick = 60000.0 / (120 * 480)
	var parser = MidiFileParser.load_file("res://assets/midi/Four_Little_Kittens.mid")
	
	for track in parser.tracks:
		var delta_ms = 0
		var player_process
		# storing internal player process in track data
		if "player_process" not in track.additional_data:
			track.additional_data.player_process = {"time" : Time.get_ticks_msec(), "event_index" : 0}
			player_process = track.additional_data.player_process
		else:
			player_process = track.additional_data.player_process
			delta_ms = Time.get_ticks_msec() - player_process.time		
			
		var delta_ticks = delta_ms / ms_per_tick
		while player_process.event_index < track.events.size():
			var event = track.events[player_process.event_index]
			if event.delta_ticks > delta_ticks:
				break
			player_process.event_index += 1
			player_process.time = Time.get_ticks_msec()
			delta_ms = 0
			delta_ticks = 0
			self.emit_signal("event", event, track)
			if event.event_type == MidiFileParser.Event.EventType.META && event.type == MidiFileParser.Meta.Type.SET_TEMPO:
				# tempo update
				ms_per_tick = event.ms_per_tick
				print("tempo now " +str(event.bpm)+ " bpm")
			if event.event_type == event.EventType.MIDI && event.note_name != '':
				var offset = event.param1 - 69
				if event.velocity > 0:
					play_sound(event.note_name, event.frequency, event.velocity)
					#print("Play "+event.note_name+" with velocity "+str(event.velocity)+" freq "+str(event.frequency))
				else:
					play_sound(event.note_name)
					#print("Stop "+event.note_name)
				
				# event.velocity <= 0 = note off
				# event.velocity > 0 = note on
				# see MidiFileParser.Midi for more information about the midi data
				pass
			
		if all_finished && player_process.event_index != track.events.size():
			all_finished = false
			
	if all_finished:		
		print("finished")
		self.emit_signal("finished")
		stop()

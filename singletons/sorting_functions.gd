extends Node

func compare_note_checkpoints(a, b):
		return a.target_time < b.target_time
		
func compare_note_events(a, b):
		return a.start_time < b.start_time

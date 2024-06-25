extends Node

func compare_note_checkpoints(a: NoteCheckpoint, b: NoteCheckpoint):
	if a.target_time == b.target_time:
		if a.checkpoint_name == "Start" || b.checkpoint_name == "End": return true
		elif a.checkpoint_name == "End" || b.checkpoint_name == "Start": return false
		else: return false
			
	return a.target_time < b.target_time
		
func compare_note_events(a: NoteEvent, b: NoteEvent):
	return a.start_time < b.start_time
	
func compare_note_checkpoint_info_boxes(a: CheckpointInfoBox, b: CheckpointInfoBox):
	return compare_note_checkpoints(a.checkpoint, b.checkpoint)

func compare_note_event_info_boxes(a: EventInfoBox, b: EventInfoBox):
	return compare_note_events(a.event, b.event)

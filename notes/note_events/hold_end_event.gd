extends EndEvent

class_name HoldEndEvent

# DIFF: ending lifetime needs to be calculated with the hold time too!
func get_ending_lifetime():
	var hold_note := note as HoldNote
	return super.get_ending_lifetime() + hold_note.hold_time

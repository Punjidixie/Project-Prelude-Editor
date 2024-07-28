extends TopInfoBox

class_name HoldTopInfoBox

@export var hold_time_input_box: LineEdit

# DIFF: one new field!
func _ready():
	super._ready()
	# Will call the note to update info
	hold_time_input_box.text_submitted.connect(on_float_input_box_updated)

# DIFF: one new field!
func update():
	super.update()
	var hold_note := note as HoldNote
	hold_time_input_box.text = str(hold_note.hold_time)
	
	

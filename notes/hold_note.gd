extends Note

class_name HoldNote

@export var hold_time: float

# DIFF: note body height needs to be calculated too
func _ready():
	super._ready()
	(note_body as HoldNoteBody).update_height()

# DIFF: a different top info box is needed
func get_and_initialize_top_info_box() -> TopInfoBox:
	var hold_top_info_box: HoldTopInfoBox = ScenePreloader.hold_top_info_box.instantiate()
	hold_top_info_box.initialize(self)
	return hold_top_info_box
	

# Height change 1: HoldNote.hold_time was changed.
func load_info_from_info_box(info_box : TopInfoBox) -> void:
	var hold_info_box := info_box as HoldTopInfoBox
	start_time = float(hold_info_box.start_time_input_box.text)
	
	note_size = float(hold_info_box.size_input_box.text)
	note_body.update_size()
	
	hold_time = float(hold_info_box.hold_time_input_box.text)
	
	# No need, will be included in update().
	# Can't set the hold_time after super though, because update() needs run after it.
	# note_body.update_height() # The hold time might have changed.
	
	var relative_end_time = float(hold_info_box.end_time_input_box.text) - start_time
	end_checkpoint.load_time_from_note(relative_end_time)
	
	#update_visibility()
	#update() 
	# No need, eventually it will reach the event and both will be picked up.

# Height change 2: position was changed
func update():
	super.update()
	(note_body as HoldNoteBody).update_height()
	


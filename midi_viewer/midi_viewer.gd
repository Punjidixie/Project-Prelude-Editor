extends Control

class_name MidiViewer

@export var midi_note_origin: CustomPlayAreaObject

var selected_midi_note: MidiNoteObject

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_time_auto_updated.connect(on_time_updated)
	SignalManager.on_time_manual_updated.connect(on_time_updated)
	SignalManager.on_midi_viewer_needs_update.connect(update)
	SignalManager.on_midi_note_selected.connect(on_midi_note_selected)
	
	spawn_midi_note_objects()
	update()

# Just spawn the notes into the tree. Positions aren't set yet.
func spawn_midi_note_objects():
	var raw_midi_notes = MidiUtils.process_midi("res://assets/midi/Four_Little_Kittens.mid")
	for raw_midi_note in raw_midi_notes:
		var midi_note_object: MidiNoteObject = ScenePreloader.midi_note_object.instantiate()
		midi_note_object.initialize_references(self, Vector2(88, 100))
		midi_note_object.initialize_midi_info(raw_midi_note)
		midi_note_origin.add_child(midi_note_object)

func _process(_delta):
	if Input.is_action_just_pressed("toggle_midi_viewer"):
		visible = not visible
	if Input.is_action_just_pressed("sync_midi_time"):
		if is_instance_valid(GlobalManager.selected_note):
			GlobalManager.selected_note.load_info_from_midi_note(selected_midi_note)

func update():
	update_midi_note_objects()
	on_time_updated()
	
# Reposition midi note objects' based on the speed
func update_midi_note_objects():
	for midi_note_object: MidiNoteObject in midi_note_origin.get_children():		
		var time = midi_note_object.midi_time / 1000
		var y_position = GlobalManager.midi_speed * time
		var x_position = midi_note_object.note - 21 # A0 = 21, C8 = 108
		midi_note_object.set_play_position(Vector2(x_position, y_position))
		
# Reposition the origin based on the speed and time.	
func on_time_updated():
	var delta_pos = GlobalManager.midi_speed * GlobalManager.current_time
	midi_note_origin.set_play_position(Vector2(0, -100 - delta_pos))
	
func on_midi_note_selected(midi_note: MidiNoteObject):
	if is_instance_valid(selected_midi_note):
		selected_midi_note.unselect()
	selected_midi_note = midi_note

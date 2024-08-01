extends Node

@export var notes: Node
@export var play_area: Control

var last_frame_time: float = 0

var debug = []
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalManager.current_time = 0
	GlobalManager.play_area = play_area
	
	# Control pausing
	SignalManager.on_time_slider_drag_started.connect(pause)
	SignalManager.on_audio_lead_time_set.connect(pause)
	SignalManager.on_audio_set.connect(pause)
	SignalManager.on_midi_set.connect(pause)
	SignalManager.on_pause_button_pressed.connect(on_pause_button_pressed)
	
	
	SignalManager.on_note_added.connect(on_note_added)

	#spawn_notes()
	SignalManager.on_time_auto_updated.emit()
	get_tree().get_root().size_changed.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GlobalManager.is_paused == false):
		auto_increment_time(delta)
	

# Note creation
func on_note_added(note: Note):
	# Set here, so the tail has the correct size when appearing for the first time.
	note.end_event.end_speed = GlobalManager.scroll_speed
	
	notes.add_child(note)
	note.go_creation_mode()
	
func auto_increment_time(delta):
	var new_time = GlobalManager.current_time + delta
	GlobalManager.current_time = new_time
	SignalManager.on_time_auto_updated.emit()

func pause():
	GlobalManager.is_paused = true
	SignalManager.on_pause_toggled.emit()

func on_pause_button_pressed():
	GlobalManager.is_paused = !GlobalManager.is_paused
	SignalManager.on_pause_toggled.emit()

func spawn_notes():
	for i in range(1):
		var note : Note = ScenePreloader.note.instantiate()
		notes.add_child(note)

	
	
	
	

	
	


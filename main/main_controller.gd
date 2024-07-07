extends Node

@export var notes: Node
@export var play_area: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalManager.current_time = 0
	GlobalManager.play_area = play_area
	SignalManager.on_time_slider_drag_started.connect(on_time_slider_drag_started)
	SignalManager.on_pause_button_pressed.connect(on_pause_button_pressed)

	spawn_notes()
	SignalManager.on_time_auto_updated.emit()
	get_tree().get_root().size_changed.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GlobalManager.is_paused == false):
		auto_increment_time(delta)
	
	
func auto_increment_time(delta):
	var new_time = GlobalManager.current_time + delta
	GlobalManager.current_time = new_time
	SignalManager.on_time_auto_updated.emit()

func on_time_slider_drag_started():
	GlobalManager.is_paused = true

func on_pause_button_pressed():
	GlobalManager.is_paused = !GlobalManager.is_paused

func spawn_notes():
	for i in range(1):
		var note : Note = ScenePreloader.note.instantiate()
		notes.add_child(note)

	
	
	
	

	
	


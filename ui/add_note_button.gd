extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(on_pressed)

func on_pressed():
	var note = ScenePreloader.note.instantiate()
	SignalManager.on_note_added.emit(note)

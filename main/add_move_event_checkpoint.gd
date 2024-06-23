extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(on_pressed)

func on_pressed():
	var event = ScenePreloader.move_event.instantiate()
	GlobalManager.selected_note.add_event(event)
	

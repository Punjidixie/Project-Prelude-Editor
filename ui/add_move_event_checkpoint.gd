extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(on_pressed)

func on_pressed():
	if is_instance_valid(GlobalManager.selected_note):
		var event: MoveEvent = ScenePreloader.move_event.instantiate()
		GlobalManager.selected_note.add_move_event(event)
	

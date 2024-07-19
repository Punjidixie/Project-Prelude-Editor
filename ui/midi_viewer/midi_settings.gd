extends Control

@export var midi_speed_input_box: LineEdit
# Called when the node enters the scene tree for the first time.
func _ready():
	midi_speed_input_box.text_submitted.connect(on_float_input_box_updated)
	update()

func update():
	midi_speed_input_box.text = str(GlobalManager.midi_speed)

func on_float_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_float():
		# Usually, info boxes calls the connected item, but they're 1-to-1 so I set it here like this. 
		GlobalManager.midi_speed = float(midi_speed_input_box.text)
		SignalManager.on_midi_viewer_needs_update.emit()
	else:
		update()

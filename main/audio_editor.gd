extends Control

@export var set_audio_button: Button
@export var lead_time_input_box: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	set_audio_button.pressed.connect(on_button_pressed)
	lead_time_input_box.text_submitted.connect(on_float_input_box_updated)
	update()

func on_button_pressed():
	GlobalManager.audio_stream = load("res://assets/Four Little Kittens.OGG")
	SignalManager.on_audio_set.emit() # Tell the stream player
	
func on_float_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_float():
		GlobalManager.audio_lead_time = float(lead_time_input_box.text)
		SignalManager.on_audio_lead_time_set.emit()
	else:
		update()

func update():
	lead_time_input_box.text = str(GlobalManager.audio_lead_time)
		

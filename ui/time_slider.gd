extends HSlider


var locked = true
# Called when the node enters the scene tree for the first time.
func _ready():
	min_value = 0
	max_value = GlobalManager.max_time
	step = 0.01
	SignalManager.on_time_auto_updated.connect(on_time_auto_updated)
	SignalManager.on_audio_set.connect(on_audio_set)
	SignalManager.on_audio_lead_time_set.connect(on_audio_lead_time_set)

func on_audio_set():
	max_value = min_value + GlobalManager.audio_stream.get_length()

func on_audio_lead_time_set():
	max_value = max_value - GlobalManager.audio_lead_time
	min_value = -GlobalManager.audio_lead_time
	
func on_time_auto_updated() -> void:
	locked = true
	value = GlobalManager.current_time # This will send _on_value_changed() signal
	locked = false

# From dragging
func _on_value_changed(value):
	if locked == false: # Locks this to when it's dragged only.
		GlobalManager.current_time = value
		SignalManager.on_time_manual_updated.emit()

func _on_drag_started():
	SignalManager.on_time_slider_drag_started.emit()

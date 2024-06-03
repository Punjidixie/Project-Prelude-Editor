extends HSlider



# Called when the node enters the scene tree for the first time.
func _ready():
	min_value = 0
	max_value = GlobalManager.max_time
	step = 0.01
	SignalManager.on_time_auto_updated.connect(on_time_auto_updated)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_time_auto_updated() -> void:
	value = GlobalManager.current_time
	pass 

func _on_value_changed(value):
	GlobalManager.current_time = value
	SignalManager.on_time_manual_updated.emit()

func _on_drag_started():
	SignalManager.on_time_slider_drag_started.emit()

extends Button



func _on_pressed():
	SignalManager.on_pause_button_pressed.emit()

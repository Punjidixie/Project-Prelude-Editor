extends CheckButton

func _on_toggled(toggled_on):
	GlobalManager.is_auto_play = toggled_on
	SignalManager.on_auto_play_set.emit()

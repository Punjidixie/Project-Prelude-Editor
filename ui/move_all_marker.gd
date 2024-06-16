extends CheckButton

func _on_toggled(toggled_on):
	GlobalManager.move_all = toggled_on

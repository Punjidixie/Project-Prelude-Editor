extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_time_auto_updated.connect(on_time_updated)
	SignalManager.on_time_manual_updated.connect(on_time_updated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_time_updated():
	text = str(GlobalManager.current_time).pad_decimals(2)

extends Node2D


signal a
var frame = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	a.connect(process_a)
	a.emit()
	print("signal a emit")
	print("ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("frame" + str(frame))
	frame += 1

func process_a():
	print("process signal a")

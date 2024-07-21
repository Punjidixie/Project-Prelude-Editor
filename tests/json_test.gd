extends Node

class MockEvent:
	var checkpoint: int
	var type: String
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var m = MockEvent.new()
	m.checkpoint = 2
	m.type = "S"
	print(inst_to_dict(m))
	


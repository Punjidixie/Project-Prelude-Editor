extends Node

class MockEvent:
	var checkpoint: int
	var type: String
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var d = {
		amo = 1,
		gus = "aaa",
		v = Vector2(1,1)
	}
	print(d.h)
	var json = JSON.new()
	
	var strd = JSON.stringify(d)
	
	print(strd)
	var parsed = json.parse(strd)

	
	


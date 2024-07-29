extends Node

@export var save_controller: SaveController
@export var notes: Node

func _ready():
	save_controller.on_open_requested.connect(load_chart)
	save_controller.on_save_requested.connect(save_chart)

func load_chart(path: String):
	pass

func save_chart(path: String):
	var notes_dict = SerializationUtils.serialize_chart(notes.get_children())
	var json = JSON.new()
	var stringified_chart = json.stringify(notes_dict)
	print(stringified_chart)

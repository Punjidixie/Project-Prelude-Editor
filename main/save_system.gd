extends Node

@export var save_controller: SaveController
@export var notes_container: Node

func _ready():
	save_controller.on_open_requested.connect(load_chart)
	save_controller.on_save_requested.connect(save_chart)

func load_chart(path: String):
	GodotUtils.delete_all_children(notes_container)
	var stringified_chart = FileUtils.load_file(path)
	var chart_dict = JSON.parse_string(stringified_chart)
	var note_dicts = chart_dict.notes
	for note_dict in note_dicts:
		var note = SerializationUtils.deserialize_note(note_dict)
		notes_container.add_child(note)

func save_chart(path: String):
	var notes_dict = SerializationUtils.serialize_chart(notes_container.get_children())
	var json = JSON.new()
	var stringified_chart = json.stringify(notes_dict, "\t")
	FileUtils.save_file(path, stringified_chart)

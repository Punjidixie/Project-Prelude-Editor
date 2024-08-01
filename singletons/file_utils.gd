extends Node


func save_file(path: String, content: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(content)

func load_file(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content

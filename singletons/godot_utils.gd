extends Node

func delete_all_children(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free

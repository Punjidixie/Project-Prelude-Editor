extends Node

func delete_all_children(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free

func sort_children(node: Node, sorting_func: Callable):
	var children = node.get_children()
	children.sort_custom(sorting_func)
	for child in children: node.remove_child(child)
	for child in children: node.add_child(child)



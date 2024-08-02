extends Node

func delete_all_children(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func sort_children(node: Node, sorting_func: Callable):
	var children = node.get_children()
	children.sort_custom(sorting_func)
	for child in children: node.remove_child(child)
	for child in children: node.add_child(child)

# Get the number in an array closest to the target number.
func get_closest_number(numbers: Array, target: float) -> float:
	var selected_number = numbers[0]
	var min_difference = abs(target - selected_number)
	
	for i in range(1, numbers.size()):
		var difference = abs(target - numbers[i])
		if difference < min_difference:
			selected_number = numbers[i]
			min_difference = difference
	
	return selected_number

# Play positions
func create_line(point_1: Vector2, point_2: Vector2, width: float, color: Color) -> Line2D:
	var l = Line2D.new()
	l.width = width
	l.default_color = color

	l.add_point(PlayAreaUtils.get_world_position(point_1))
	l.add_point(PlayAreaUtils.get_world_position(point_2))
	
	return l


func is_between(target: float, lower_bound: float, upper_bound: float) -> bool:
	if target < lower_bound or target > upper_bound:
		return false

	return true



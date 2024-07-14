extends Node

class_name CurveEditor

@export var path_point_container: Control
@export var new_path_point_button: Button
@export var front_label: CurveEditorFrontLabel

var move_event: MoveEvent

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_move_event_selected.connect(on_move_event_selected)
	SignalManager.on_note_selected.connect(on_note_selected)
	SignalManager.on_path_point_info_box_added.connect(add_path_point_info_box)
	new_path_point_button.pressed.connect(on_new_path_point_button_pressed)

func on_move_event_selected(_move_event: MoveEvent):
	GodotUtils.delete_all_children(path_point_container)
	if is_instance_valid(_move_event):
		populate_ui(_move_event)
	else:
		front_label.show_unselected()
		front_label.set_visible(true)

func on_note_selected(_note: Note):
	on_move_event_selected(null)

func populate_ui(_move_event: MoveEvent):
	move_event = _move_event

	var path_point_info_boxes = move_event.get_path_point_info_boxes()
	if path_point_info_boxes.is_empty(): 
		front_label.show_no_points()
		front_label.set_visible(true)
	else:
		front_label.set_visible(false)
		for info_box in path_point_info_boxes:
			path_point_container.add_child(info_box)
	
	
func on_new_path_point_button_pressed():
	if is_instance_valid(move_event):
		move_event.add_curve_point()

# Will eventually be called after the function above.
func add_path_point_info_box(info_box: PathPointInfoBox):
	path_point_container.add_child(info_box)
	front_label.set_visible(false)
	
	
	
	



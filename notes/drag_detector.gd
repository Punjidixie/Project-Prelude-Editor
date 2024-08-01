extends Control

class_name DragDetector

var mouse_held = false
var following_mouse = false
var drag_position : Vector2 # the local mouse position where it started to get dragged
@export var mouse_button: MouseButton = MOUSE_BUTTON_LEFT
@export var ignore_snap: bool = false
@export var ignore_border: bool = false
@export var drag_threshold: float = 1

var mouse_in = false # to be able to start following mouse
var action_name: String = "left_click"

signal on_clicked()
signal on_dragged(amount: Vector2)
signal on_released()

func _ready():
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
		
func follow_mouse():
	# Given the current mouse position, where should the parent be? Emit the move signal.
	# On the next frame if the mouse is not moved, the parent would be where it should be.
	# Amount moved emitted would be zero.
	var parent_global_position = self.global_position + Vector2(1, 1) * (size / 2)
	var drag_position_parent = drag_position - Vector2(1, 1) * (size / 2) # relative to the parent
	
	# New global position OF THE PARENT
	var new_global_position = get_global_mouse_position() - drag_position_parent
	
	if ignore_snap == false:
		new_global_position = GridUtils.get_snapped_position(new_global_position)
	
	if ignore_border == false:
		new_global_position = GridUtils.get_border_clamped_position(new_global_position)
		
	var amount_moved = new_global_position - parent_global_position
	on_dragged.emit(amount_moved)
	if Input.is_action_just_released(action_name):
		following_mouse = false
		on_released.emit()
	
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == mouse_button:
			following_mouse = false
			if event.pressed:
				mouse_held = true # Held, but don't follow yet!
				drag_position = get_local_mouse_position()
				on_clicked.emit()
			else:
				mouse_held = false
				on_released.emit()
	elif event is InputEventMouseMotion:
		if following_mouse: follow_mouse()
		elif mouse_held:
			if PlayAreaUtils.get_delta_play_position(event.relative).length() >= drag_threshold:
				following_mouse = true	# Looks like we really want to drag. Can follow now.
		
### OLD ALGORITHM BELOW ###
func process(_delta):
	if mouse_in:
		if Input.is_action_just_pressed(action_name):
			drag_position = get_local_mouse_position()
			following_mouse = true
			on_clicked.emit()

	if following_mouse:
		follow_mouse()
		
func on_mouse_entered():
	mouse_in = true
	
func on_mouse_exited():
	mouse_in = false

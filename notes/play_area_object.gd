extends Node2D

class_name PlayAreaObject

enum PlayAreaMode {ABSOLUTE, RELATIVE}

@export var play_position : Vector2
@export var coordinate_mode: PlayAreaMode = PlayAreaMode.ABSOLUTE

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().size_changed.connect(on_viewport_size_changed)
	update_world_position()
	
func on_viewport_size_changed():
	update_world_position()

func set_play_position(new_play_position : Vector2):
	play_position = new_play_position
	update_world_position()

func set_world_position(new_world_position : Vector2):
	position = new_world_position
	update_play_position()

func update_world_position():
	if coordinate_mode == PlayAreaMode.ABSOLUTE:
		position = PlayAreaUtils.get_world_position(play_position)
	else:
		position = PlayAreaUtils.get_delta_world_position(play_position)

func update_play_position():
	if coordinate_mode == PlayAreaMode.ABSOLUTE:
		play_position = PlayAreaUtils.get_play_position(position)
	else:
		play_position = PlayAreaUtils.get_delta_play_position(position)

	
	


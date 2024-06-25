extends Node2D

class_name PlayAreaObject

@export var play_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().size_changed.connect(on_viewport_size_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_viewport_size_changed():
	update_world_position()

func set_play_position(new_play_position : Vector2):
	play_position = new_play_position
	update_world_position()

func set_world_position(new_world_position : Vector2):
	position = new_world_position
	update_play_position()

func update_world_position():
	position = PlayAreaUtils.get_world_position(play_position)

func update_play_position():
	play_position = PlayAreaUtils.get_play_position(position)

	
	


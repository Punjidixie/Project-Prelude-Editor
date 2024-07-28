extends PlayAreaObject

class_name NoteBody

@export var mouse_follower: MouseFollower
@export var note: Note
@export var drag_detector: DragDetector
@export var body: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	mouse_follower.on_cancelled.connect(on_creation_cancelled)
	mouse_follower.on_confirmed.connect(on_creation_confirmed)
	mouse_follower.on_zone_entered.connect(on_creation_zone_entered)
	mouse_follower.on_zone_exited.connect(on_creation_zone_exited)
	mouse_follower.on_moved.connect(waiting_move_by)
	
	drag_detector.on_clicked.connect(on_clicked)
	drag_detector.on_dragged.connect(on_dragged)
	
	get_tree().get_root().size_changed.connect(update_size)
	
	go_regular_mode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Called from mouse follower.
func waiting_move_by(amount: Vector2) -> void:
	set_world_position(position + amount)
	var delta_play_position = PlayAreaUtils.get_delta_play_position(amount)
	note.move_by(Vector2(delta_play_position.x, 0)) # Move the note by the same amount horizontally

func on_dragged(amount: Vector2) -> void:
	var amount_horizontal = Vector2(amount.x, 0)
	set_world_position(position + amount_horizontal)
	var delta_play_position = PlayAreaUtils.get_delta_play_position(amount_horizontal)
	note.move_by(delta_play_position) # Move the note by the same amount horizontally

func update_size():
	var world_size = PlayAreaUtils.get_delta_world_position(Vector2.ONE * note.note_size)
	body.size.x = world_size.x / body.scale.x
	
	body.position = - (body.size / 2) * body.scale

func update_appearance():
	pass

# Creation mode: following the cursor, waiting to be added to the note
func go_creation_mode():
	mouse_follower.process_mode = Node.PROCESS_MODE_INHERIT
	drag_detector.process_mode = Node.PROCESS_MODE_DISABLED

# Regular mode: editor, ready to be dragged
func go_regular_mode():
	mouse_follower.process_mode = Node.PROCESS_MODE_DISABLED
	drag_detector.process_mode = Node.PROCESS_MODE_INHERIT

func on_creation_confirmed():
	note.on_creation_confirmed()

func on_creation_cancelled():
	note.on_creation_cancelled()

func on_creation_zone_exited():
	note.on_creation_zone_exited()

func on_creation_zone_entered():
	note.on_creation_zone_entered()

func on_clicked():
	note.get_selected()

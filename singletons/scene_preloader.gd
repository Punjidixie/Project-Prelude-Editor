extends Node


const checkpoint_info_box = preload("res://ui/checkpoint_info_boxes/checkpoint_info_box.tscn")

const event_info_box = preload("res://ui/event_info_boxes/event_info_box.tscn")
const appear_event_info_box = preload("res://ui/event_info_boxes/appear_event_info_box.tscn")
const move_event_info_box = preload("res://ui/event_info_boxes/move_event_info_box.tscn")
const end_event_info_box = preload("res://ui/event_info_boxes/end_event_info_box.tscn")
const path_point_info_box = preload("res://ui/event_info_boxes/path_point_info_boxes/path_point_info_box.tscn")
const top_info_box = preload("res://ui/top_info_box.tscn")
const hold_top_info_box = preload("res://ui/hold_top_info_box.tscn")

const note_checkpoint = preload("res://notes/note_checkpoint.tscn")
const move_event = preload("res://notes/note_events/move_event.tscn")
const path_point = preload("res://notes/note_events/path_points/path_point.tscn")

# Note creation
const note = preload("res://notes/note.tscn")
const hold_note = preload("res://notes/hold_note.tscn")
const drag_note = preload("res://notes/drag_note.tscn")
const flick_note = preload("res://notes/flick_note.tscn")

# Note loading
const base_note = preload("res://notes/base_notes/base_note.tscn")
const base_hold_note = preload("res://notes/base_notes/base_hold_note.tscn")
const base_drag_note = preload("res://notes/base_notes/base_drag_note.tscn")
const base_flick_note = preload("res://notes/base_notes/base_drag_note.tscn")

const midi_note_object = preload("res://midi_viewer/midi_note_object.tscn")

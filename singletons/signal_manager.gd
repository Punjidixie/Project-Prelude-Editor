extends Node

signal on_time_updated()
signal on_time_auto_updated()
signal on_time_manual_updated()

signal on_time_slider_drag_started()
signal on_pause_button_pressed()

signal on_note_selected(note: Note)
signal on_top_ui_needs_update()

signal move_all_by(called_from: NoteCheckpoint, amount: Vector2)

extends Node

signal on_time_updated()
signal on_time_auto_updated()
signal on_time_manual_updated()

signal on_time_slider_drag_started()
signal on_pause_button_pressed()

signal on_note_selected(note: Note)
signal on_note_added(note: Note)

# Note info boxes
signal on_new_checkpoint_info_box_added(info_box: CheckpointInfoBox)
signal on_checkpoint_info_boxes_need_reordering()
signal on_new_event_info_box_added(info_box: EventInfoBox)
signal on_event_info_boxes_need_reordering()

signal on_top_ui_needs_update()

# Path points
signal on_move_event_selected(move_event: MoveEvent)
signal on_path_point_info_box_added(info_box: PathPointInfoBox)

# Grid : UI -> drawer
signal on_grid_drawer_needs_update()

# Midi : UI -> drawer
signal on_midi_viewer_needs_update()


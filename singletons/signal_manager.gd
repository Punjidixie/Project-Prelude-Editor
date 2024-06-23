extends Node

signal on_time_updated()
signal on_time_auto_updated()
signal on_time_manual_updated()

signal on_time_slider_drag_started()
signal on_pause_button_pressed()

signal on_note_selected(note: Note)

signal on_new_checkpoint_info_box_added(info_box: CheckpointInfoBox)
signal on_checkpoint_info_boxes_need_reordering()
signal on_new_event_info_box_added(info_box: EventInfoBox)
signal on_event_info_boxes_need_reordering()

signal on_top_ui_needs_update()

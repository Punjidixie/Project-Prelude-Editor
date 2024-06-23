extends EventInfoBox

class_name AppearEventInfoBox

@export var time_label: Label

func update():
	super.update()
	var appear_event := event as AppearEvent
	time_label.text = str(appear_event.start_time)
	SignalManager.on_event_info_boxes_need_reordering.emit()

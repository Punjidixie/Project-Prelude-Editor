extends EventInfoBox

class_name EndEventInfoBox

@export var time_label: Label

func update():
	super.update()
	var end_event := event as EndEvent
	time_label.text = str(end_event.start_time)
	SignalManager.on_event_info_boxes_need_reordering.emit()

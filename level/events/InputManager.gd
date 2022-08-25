extends Control

export var UnitDragEvent: Resource
export var UnitCaptureEvent: Resource
	
#send out input event to our different events
func _input(event):
	UnitDragEvent.on_input_event(event);
	UnitCaptureEvent.on_input_event(event);
		

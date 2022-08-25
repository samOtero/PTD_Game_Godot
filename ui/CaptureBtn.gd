extends Button


export var unitCaptureEvent: Resource

func get_drag_data(_position):
	unitCaptureEvent.do_start_capturing()
	set_drag_preview(self.duplicate())
	return "bob"

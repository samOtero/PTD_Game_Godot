extends Button


var unitCaptureEvent


# Called when the node enters the scene tree for the first time.
func _ready():
	# Getting a reference of our unit capture event
	unitCaptureEvent =  get_node("/root").get_node_or_null("GameRoot/Events/EventCapture")
	if (unitCaptureEvent == null): print('Unit Container: MISSING unitCaptureEvent, will prevent functionality of capturing a unit!')


func get_drag_data(_position):
	unitCaptureEvent.do_start_capturing()
	set_drag_preview(self.duplicate())
	return "bob"

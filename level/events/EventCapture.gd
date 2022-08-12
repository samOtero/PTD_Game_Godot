extends Control

signal started_capturing
signal end_capturing

export var PauseStatus: Resource

var selectedUnit
var isCapturing: bool

func do_start_capturing():
	isCapturing = true
	emit_signal("started_capturing")
	PauseStatus.doPause(); # Pause when we start dragging our capture
	
func do_end_capturing():
	isCapturing = false
	emit_signal("end_capturing")
	PauseStatus.doUnpause();
	

func do_hover_unit(whichUnit):
	selectedUnit = whichUnit
	
func do_exit_unit(_whichUnit):
	selectedUnit = null
	
func _input(event):
	# If the event is releasing the mouse button then we want to consume it
	if (event is InputEventMouseButton && event.pressed == false):
		# If we aren't hovering over anything or not capturing then ignore the events
		if (selectedUnit != null && isCapturing == true):
			selectedUnit.doCapture();
		# End capturing if necessary
		if (isCapturing == true): do_end_capturing()
		
		

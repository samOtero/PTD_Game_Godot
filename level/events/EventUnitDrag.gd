extends Control

signal unit_start_drag(whichUnit)

var draggedUnit
var selectedSpot
export var PauseStatus: Resource


func do_unit_start_drag(whichUnit, fromUIButton):
	draggedUnit = whichUnit
	PauseStatus.doPause() # Pause the game while we are dragging
	emit_signal("unit_start_drag", whichUnit, fromUIButton)
	

func do_enter_spot(whichSpot):
	selectedSpot = whichSpot
	
func do_exit_spot(_whichSpot):
	selectedSpot = null
	
func _input(event):
	# If we aren't dragging anything then ignore the events
	if (draggedUnit == null): return
	# If the event is releasing the mouse button then we want to consume it
	if (event is InputEventMouseButton && event.pressed == false):
		PauseStatus.doUnpause() # Unpause the game when we stop dragging
		if (selectedSpot != null):
			selectedSpot.addUnitToSpot(draggedUnit)
		else:
			draggedUnit.removeFromBattle()
		draggedUnit = null
		

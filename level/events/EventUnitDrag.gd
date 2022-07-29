extends Control

signal unit_start_drag(whichUnit)

var draggedUnit
var selectedSpot


func do_unit_start_drag(whichUnit, fromUIButton):
	print('unit start drag event triggered! sending it to all registered nodes!')
	draggedUnit = whichUnit
	emit_signal("unit_start_drag", whichUnit, fromUIButton)
	

func do_enter_spot(whichSpot):
	print("enter spot event triggered!")
	selectedSpot = whichSpot
	
func do_exit_spot(_whichSpot):
	print ("exit spot event triggered!")
	selectedSpot = null
	
func _input(event):
	# If we aren't dragging anything then ignore the events
	if (draggedUnit == null): return
	# If the event is releasing the mouse button then we want to consume it
	if (event is InputEventMouseButton && event.pressed == false):
		if (selectedSpot != null):
			selectedSpot.addUnitToSpot(draggedUnit)
		else:
			draggedUnit.removeFromBattle()
		draggedUnit = null
		

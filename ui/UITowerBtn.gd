extends Button


var unitDragEvent
var myUnit


# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: Get actual tower instead of hardcoding here
	myUnit = get_tree().get_nodes_in_group("tower")[0]
	# Getting a reference of our unit start drag event
	unitDragEvent = owner.get_node_or_null("Events/EventUnitDrag")
	if (unitDragEvent != null): unitDragEvent.connect("unit_start_drag", self, "_on_Unit_Start_Drag")
	if (unitDragEvent == null): print('Tower Button: MISSING unitDragEvent, will prevent functionality of dragging a unit from a spot!')

func _on_Unit_Start_Drag(whichUnit, fromUIButton):
	if (fromUIButton == true): return # Don't force drag if doing it from button
	if (whichUnit != myUnit): return
	#TODO: Have unit be in the correct position
	# Can do this by putting the unit in a parent and changing the position in there
	force_drag(myUnit, get_node("3DUnitUI").duplicate())

# Called when dragging button
func get_drag_data(_position):
	# Sending to event to handle
	unitDragEvent.do_unit_start_drag(myUnit, true)
	set_drag_preview( get_node("3DUnitUI").duplicate())
	return myUnit

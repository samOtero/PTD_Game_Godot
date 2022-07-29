extends MeshInstance

var myUnit
var unitDragEvent


# Called when the node enters the scene tree for the first time.
func _ready():
	# Getting a reference of our unit start drag event
	unitDragEvent = owner.get_node_or_null("Events/EventUnitDrag")
	if (unitDragEvent == null): print('Tower Spot: MISSING unitDragEvent, will prevent functionality of dragging a unit from a spot!')

func _on_entered():
	unitDragEvent.do_enter_spot(self)
	
func _on_exit():
	unitDragEvent.do_exit_spot(self)

# This will received an input event from the mouse when it happens on the tower spot
# We want to identify when the input is released at this spot, to potentially add a unit to it
func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if (event is InputEventMouseButton):
		if (event.pressed == true): # If we are starting the drag here
			# If we have a unit to drag
			if (myUnit != null):
				# Trigger the drag
				if (unitDragEvent != null): unitDragEvent.do_unit_start_drag(myUnit, false)
				event.pressed = false # HACK: This fixes an issue with not being able to detect mouse over/exit on tower spots
			
		

# Handles adding a unit to this spot, will also swap with any other unit
func addUnitToSpot(newUnit):
	# If we are adding the unit that is already here then do nothing
	if (myUnit == newUnit): return
	
	# Remove the new unit from it's previous spot
	if (newUnit.currentSpot != null): newUnit.currentSpot.removeUnit(newUnit)
	
	# If this spot already had a unit
	if (myUnit != null):
	# Check to see if new unit came from a spot
		if (newUnit.currentSpot != null):
		# Swap unit spots
			var newUnitSpot = newUnit.currentSpot
			newUnitSpot.AddUnit(myUnit) # Swap the unit but ignore additional swaps
		else:
			# Callback unit
			myUnit.removeFromBattle()

	myUnit = newUnit
	myUnit.currentSpot = self
	# Place unit in tower spot
	myUnit.transform.origin = self.transform.origin
	myUnit.setIsBattling(true) # When added to a spot the unit is now battling!
	
func removeUnit(unitToRemove):
	if (myUnit != unitToRemove): return
	myUnit = null
		

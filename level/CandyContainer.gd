extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var onFloor
var originalParent

# Called when the node enters the scene tree for the first time.
func _ready():
	onFloor = true
	originalParent = get_parent()
	
func onDrop():
	onFloor = true
	attachToNewParent(originalParent)
	
func onPickup(whichUnit):
	onFloor = false
	attachToNewParent(whichUnit)
	
func onCaptured():
	onFloor = false
	queue_free() # remove from level
	# TODO: Add captured candy event
	
func canPickup():
	return onFloor
	
# Attaches candy to new parent but retains global positioning
func attachToNewParent(newParent):
	# Save our current global position
	var globalPos = global_transform
	# Deattach from current parent and attach to unit
	get_parent().remove_child(self)
	newParent.add_child(self)
	global_transform = globalPos #set our candy back to it's global transform
	

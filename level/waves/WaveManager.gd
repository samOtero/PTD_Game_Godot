extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var path1Path: NodePath
var path1

var tempFlag = false


# Called when the node enters the scene tree for the first time.
func _ready():
	path1 = get_node(path1Path)
	# Connect to event signal
	var unitLeftEvent = owner.get_node("Events/EventUnitLeft")
	if (unitLeftEvent != null): unitLeftEvent.connect("unit_left", self, "_on_Unit_Left_Event")
	else: print("WaveManager: MISSING unitLeftEvent!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (!tempFlag):
		tempFlag = true
		
func _on_Unit_Left_Event(whichUnit):
	# Remove from game
	#TODO: add object pooling here
	print("Received signal for unit left, removing from game!")
	whichUnit.queue_free()

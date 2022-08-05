extends Node

var isCompleted: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	isCompleted = false


func _onRun():
	if (isCompleted == true): return
	var allSegmentsCompleted = true
	
	for segment in self.get_children():
		segment._onRun()
		if (segment.isCompleted == false): allSegmentsCompleted = false
	
	if (allSegmentsCompleted == true): isCompleted = true

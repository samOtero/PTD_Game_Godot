extends Node

export var PauseStatus: Resource
export var RunEvent: Resource

var speed: int = 1


# This will send out a signal to our level nodes to run their code, we send out more signals when the game is going faster
func _process(delta):
	if (PauseStatus.isPaused() == true): return # Don't send out run signal if game is paused
	RunEvent.triggerRun(delta) # This will trigger our Resource to emit the run signal

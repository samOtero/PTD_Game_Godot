extends Node

export var RunEvent: Resource
signal run_effects

func _ready():
	# Connect to do_run signal from event
	var _error_code = RunEvent.connect("do_run", self, "_onRun")

func _onRun(delta):
	emit_signal("run_effects", delta)

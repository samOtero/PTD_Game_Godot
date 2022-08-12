extends Resource
class_name RunEvent

# Resource used by nodes to connect to the signal to run their logic

signal do_run(delta)

# This will be triggerred by a speed manager
func triggerRun(delta):
	emit_signal("do_run", delta)

extends Node

signal run_effects

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#TODO: tie this to level run event, as that will handle fast speed
	emit_signal("run_effects")

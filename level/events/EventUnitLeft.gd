extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal unit_left(whichUnit)


func do_unit_left(whichUnit):
	print('unit left event triggered! sending it to all registered nodes!')
	emit_signal("unit_left", whichUnit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

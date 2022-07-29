extends Node

signal unit_left(whichUnit)


func do_unit_left(whichUnit):
	print('unit left event triggered! sending it to all registered nodes!')
	emit_signal("unit_left", whichUnit)

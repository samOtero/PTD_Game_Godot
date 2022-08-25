extends Resource
class_name LevelEvent

signal unit_left(whichUnit)
signal spawn_unit_in_path(profile, pathNum)


func do_unit_left(whichUnit):
	emit_signal("unit_left", whichUnit)
	
func do_spawn_unit_in_path(profile, pathNum):
	emit_signal("spawn_unit_in_path", profile, pathNum)

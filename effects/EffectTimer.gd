extends Effect

# This effect will end after it's delay
class_name EffectTimer

func _init(newDelay: int = 0, newTag: String = "", newTag2: String = "").(newDelay, newTag, newTag2):
	pass
	
func doRunCustom(delta):
	# Call parent class version
	.doRunCustom(delta)
	if (needRemove == true): return
	doCleanUp()
		
	

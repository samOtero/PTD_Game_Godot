extends Effect

# This effect will end after it's delay
class_name EffectTimer

func _init(newDelay: int = 0, newTag: String = "", newTag2: String = "").(newDelay, newTag, newTag2):
	pass
	
func doRunCustom():
	# Call parent class version
	.doRunCustom()
	if (needRemove == true): return
	doCleanUp()
		
	

extends Effect

# This effect will fade a unit
class_name Effect_Fade

var unit
var didFade: bool
var fadeAmount: float

func _init(newUnit, newFadeAmount: float=0.2, newDelay: int = 0, newTag: String = "", newTag2: String = "").(newDelay, newTag, newTag2):
	unit = newUnit
	didFade = false
	fadeAmount = newFadeAmount
	
func doRunCustom(delta):
	# Call parent class version
	.doRunCustom(delta)
	if (needRemove == true): return
	if (didFade == true): return
	if (unit.isAlive == false): return
	unit.doFade(fadeAmount)
	didFade = true
	
func doRemoveCustom():
	.doRemoveCustom()
	if (didFade): unit.doFade(1.0) # TODO: This should probably return back to original or do something a bit different
		

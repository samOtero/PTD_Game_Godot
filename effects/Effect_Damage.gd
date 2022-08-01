extends EffectForUnit

# This effect will deal damage to a target
class_name Effect_Damage

var amount: int
var attackerNeedsAlive: bool

func _init(newTarget: Spatial, newFromWho: Spatial, newAmount:int, newAttackerNeedsAlive: bool, newDelay: int = 0, newTag: String = "", newTag2: String = "").(newTarget, newFromWho, newDelay, newTag, newTag2):
	amount = newAmount
	attackerNeedsAlive = newAttackerNeedsAlive

func doRunCustom(delta):
	.doRunCustom(delta)
	if (needRemove == true): return
	if (attackerNeedsAlive == true && fromWho.isAlive == false):
		doCleanUp()
		return
	if (target.getID() == targetId):
		target.takeDamage(amount, fromWho)
	
	doCleanUp()

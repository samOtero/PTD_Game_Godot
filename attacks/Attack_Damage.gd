extends Attack

class_name Attack_Damage

func _init(unit: Node).(unit):
	pass

# Properties for this attack
func initProperties():
	.initProperties()
	isPhysical = true
	initialCooldown = 30
	attackerNeedsAlive = true
	power = 10
	atkRange = 30.0
	
func doAttackActual():
	#Get target in range
	var target = getTargetInRange()
	if (target != null):
		faceTarget(target)
		var damageFx = Effect_Damage.new(target, unit, power, attackerNeedsAlive)
		damageFx.doInit(getEffectContainer())
		reset()
		return 1
	return 0

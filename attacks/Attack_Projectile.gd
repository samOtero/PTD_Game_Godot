extends Attack

class_name Attack_Projectile

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
		#TODO: Get damage from attack calculation
		var damageAmount = power
		var projectileEffect = Effect_Projectile.new(target, unit, attackerNeedsAlive)
		var damageFx = Effect_Damage.new(target, unit, damageAmount, attackerNeedsAlive)
		var fadeEffect = Effect_Fade.new(unit)
		projectileEffect.addToEndStack(damageFx) # Do Damage at the end of projectile
		projectileEffect.addToStack(fadeEffect); # Fade unit while projectile is active
		projectileEffect.doInit(getEffectContainer())
		reset()
		return 1
	return 0

extends Node

class_name Attack

var unit: Spatial
var targetList: Array
var atkRange: float
var currentCooldown: int
var targetFriendly: bool
var initialCooldown: int
var attackerNeedsAlive: bool
var power: int
var moveType
var isPhysical: bool
var stab: float
var isNonDamagingAttack: bool

enum DIRECTION { NORTH, SOUTH, EAST, WEST }


func _init(newUnit: Spatial):
	unit = newUnit
	initProperties()
	reset()
	
# Implement properties in subclasses
func initProperties():
	pass
	
func reset():
	currentCooldown = initialCooldown
	
func runCooldown():
	if (currentCooldown > 0): currentCooldown -= 1
	
func doAttack():
	if (currentCooldown > 0): return 0
	#TODO: Handle non damaging attack
	return doAttackActual()

func doAttackActual():
	# Implement rest in sub clas
	reset()
	return 0

func getTargetInRange():
	#TODO: Add Range to equation
	#TODO: Figure out not getting the list every time
	var enemyList = get_tree().get_nodes_in_group("enemy");
	if (enemyList.size() == 0): return null
	var target = enemyList[0]
	var targetLoc = Vector2(target.transform.origin.x, target.transform.origin.z)
	var attackerLoc = Vector2(unit.transform.origin.x, unit.transform.origin.z)
	var distance = targetLoc.distance_squared_to(attackerLoc)
	if (distance <= atkRange): return target
	return null
	
func getEffectContainer():
	return get_tree().get_nodes_in_group("effectContainer")[0]
	
func faceTarget(target):
	var targetLoc = target.transform.origin
	var atkZ = unit.transform.origin.z
	var atkX = unit.transform.origin.x
	var zDelta = abs(atkZ - targetLoc.z)
	var xDelta = abs(atkX - targetLoc.x)
	var newDirection = DIRECTION.NORTH
	if (zDelta > xDelta):
		if (atkZ > targetLoc.z):
			newDirection = DIRECTION.NORTH
		else:
			newDirection = DIRECTION.SOUTH
	else:
		if (atkX > targetLoc.x):
			newDirection = DIRECTION.WEST
		else:
			newDirection = DIRECTION.EAST
	unit.faceDirection(newDirection)

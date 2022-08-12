extends EffectForUnit

# This effect will creates a projectile that will reach it's destination
class_name Effect_Projectile

enum DIRECTION { NORTH, SOUTH, EAST, WEST }

var attackerNeedsAlive: bool
var initProjectile: bool
var projectileSpeed: float
var projectileGfx
# This is the mesh we want to rotate
var rotationGfx
var targetLocation
var targetRange: float

func _init(newTarget: Spatial, newFromWho: Spatial, newAttackerNeedsAlive: bool, newDelay: int = 0, newTag: String = "", newTag2: String = "").(newTarget, newFromWho, newDelay, newTag, newTag2):
	attackerNeedsAlive = newAttackerNeedsAlive
	initProjectile = true
	# TODO: bring this in from the attack
	projectileSpeed = 12.0
	targetRange = pow(projectileSpeed, 2)

func doRunCustom(delta):
	.doRunCustom(delta)
	if (needRemove == true): return
	if (attackerNeedsAlive == true && fromWho.isAlive == false):
		doCleanUp()
		return
	
	# If we haven't created our projectile then let's do that
	if (initProjectile == true):
		# If the target is no longer available then don't try to start this
		if (target.getID() != targetId):
			doCleanUp()
			return
		create_projectile()
		initProjectile = false
		targetLocation = target.global_transform.origin
		return
	
	# We have our projectile, let's get to the target
	updateTargetLocation()
	
	#Move projectile
	var velocity = GetVelocity()
	projectileGfx.translate(velocity * delta)
	faceTarget()
	
	# Check if we hit our target
	if (checkIfHitTarget(delta)):
		hitTarget()
		
# Returns true if we reached out target location
func checkIfHitTarget(delta):
	var targetLoc = Vector2(targetLocation.x, targetLocation.z)
	var currentLoc = Vector2(projectileGfx.global_transform.origin.x, projectileGfx.global_transform.origin.z)
	var distance = currentLoc.distance_squared_to(targetLoc)
	var currentRange = projectileSpeed * delta
	if (distance < currentRange): return true
	return false
	
# Called when projectile reaches it's target location
func hitTarget():
	# If we hit the target then end the effect
	doCleanUp()
	
func create_projectile():
	var unitScene = load("res://creatureGfx/"+fromWho.unitName+"_gfx.tscn")
	projectileGfx = unitScene.instance()
	add_child(projectileGfx)
	# Set location for projectile
	projectileGfx.global_transform.origin = fromWho.global_transform.origin
	rotationGfx = projectileGfx.get_node(fromWho.unitName)

func updateTargetLocation():
	if (target == null || !weakref(target).get_ref()):
		target = null;
		return;
	# If we have a target and it's dead then don't update our location
	if (target.isTargetable() == false || target.getID() != targetId):
		target = null # Target is dead let's get rid of it and hit our last target
		return
	targetLocation = target.global_transform.origin
	
# Get Velocity to target location
func GetVelocity():
	return projectileGfx.global_transform.origin.direction_to(targetLocation) * projectileSpeed
	
func faceTarget():
	var targetLoc = targetLocation
	var atkZ = projectileGfx.global_transform.origin.z
	var atkX = projectileGfx.global_transform.origin.x
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
	faceDirection(newDirection)
	
func faceDirection(newDirection):
	var rotation = getRotationFromDirection(newDirection)
	# rotate our unit to face the new direction
	rotationGfx.rotation_degrees = Vector3(0, rotation, 0)
	pass
	
func getRotationFromDirection(whichDirection):
	var newRotation = 0.0
	match whichDirection:
		DIRECTION.NORTH:
			newRotation = 180.0
		DIRECTION.SOUTH:
			newRotation = 0.0
		DIRECTION.EAST:
			newRotation = 90.0
		DIRECTION.WEST:
			newRotation = -90.0
	return newRotation

extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var unit
var currentDirection
var initialPoint
var currentPoint
var targetPoint
var turnedAround
var freeRoam
var dontLeave
var canCaptureCandy
var hasCandy
var carriedCandy
var candyRange
var directionVector
var velocityVector
var candyList
var eventsRegistered = false
var unitLeftEvent

enum DIRECTION { NORTH, SOUTH, EAST, WEST }


# Called when the node enters the scene tree for the first time.
func _ready():
	unit = owner
	candyRange = pow(0.7, 2) # using to calculate distance squared
	
	# Getting a reference of our unit left event
	unitLeftEvent = owner.owner.get_node_or_null("Events/EventUnitLeft")
	if (unitLeftEvent == null): print('WalkPointFollower: MISSING unitLeftEvent, this should only happen when testing without events, will use backup functionality!')
	
	#TODO: remove this, just using it for testing
	var startPoint = owner.owner.get_node("Path1/WalkPoint")
	reset(startPoint)
	
func reset(startPoint):
	initialPoint = startPoint
	#set our location to the starting point
	unit.transform.origin = initialPoint.transform.origin
	#TODO: set these three from profile
	dontLeave = true
	canCaptureCandy = true
	freeRoam = false
	turnedAround = false #reset turned around as well
	directionVector = -Vector3.FORWARD
	velocityVector = directionVector * unit.currentSpeed
	setNewPoint(initialPoint)
	candyList = get_tree().get_nodes_in_group("candy")
	if (eventsRegistered == false):
		# TODO: Add run effect things here
		eventsRegistered = true
		
func dropCandy():
	if (!hasCandy): return
	carriedCandy.onDrop()
	hasCandy = false
	carriedCandy = null

func checkForCandy():
	if (hasCandy): return;
	# Check to see if any candy are in our range
	var candyInRange = getCandyInRange()
	if (candyInRange != null):
		hasCandy = true;
		# Attach candy to unit and set candy as caught
		carriedCandy = candyInRange
		var candyGlobalTransfrom = carriedCandy.global_transform
		carriedCandy.onPickup(unit)
		carriedCandy.get_parent().remove_child(carriedCandy)
		unit.add_child(carriedCandy)
		carriedCandy.global_transform = candyGlobalTransfrom #set our candy back to it's global transform
		# Turn around back to our exit point
		if (!freeRoam && !turnedAround):
			turnedAround = !turnedAround
			setNewPoint(targetPoint)
	
func getCandyInRange():
	var unitLoc = Vector2(unit.transform.origin.x, unit.transform.origin.z)
	var candyLoc = Vector2.ZERO
	var distance = 0.0
	if (candyList == null):
		print("WayPointFollower: Candy List is null")
		return null
	for candy in candyList:
		if (!candy || !weakref(candy).get_ref()): continue
		if (candy.canPickup() == false): continue
		candyLoc.x = candy.transform.origin.x
		candyLoc.y = candy.transform.origin.z
		distance = candyLoc.distance_squared_to(unitLoc)
		if (distance <= candyRange): return candy
		
	return null
	
func setNewPoint(newPoint):
	currentPoint = newPoint
	targetPoint = GetTargetPoint(currentPoint)
	
	# Check to see if we got to the end
	if (targetPoint == null):
		# If we can turn around then we want to cycle
		if (!freeRoam && (dontLeave || !turnedAround)):
			# If we reached the exit then try to capture candy, even if we aren't leaving the level
			if (dontLeave && turnedAround): doCaptureCandy()
			turnedAround = !turnedAround
			targetPoint = GetTargetPoint(currentPoint)
		else:
			# If we reached our end
			# If we have candy then we want to capture it
			doCaptureCandy()
			# Send unit left event when we reach our end
			if (unitLeftEvent != null): unitLeftEvent.do_unit_left(unit)
			else:
				# Including some fallback functionality, incase we want to test this without the event
				print("WalkPointFollower: unitLeftEvent not found, using fallback functionality!")
				unit.queue_free()
				
	getNewRotation(currentPoint, turnedAround)

func doCaptureCandy():
	if (!hasCandy): return
	carriedCandy.onCaptured()
	hasCandy = false
	carriedCandy = null
	
# Gets the next way point we are heading to based on the given one
func GetTargetPoint(whichPoint):
	if (turnedAround):
		return whichPoint.prevPoint
	return whichPoint.nextPoint
	
func getNewRotation(whichPoint, isTurnedAround):
	# Get unit's direction from point
	var newDirection = whichPoint.forwardDirection if !isTurnedAround else whichPoint.backwardDirection
	currentDirection = newDirection
	unit.faceDirection(currentDirection)
	
func onDoRun(delta):
	if (unit == null): return 0
	if (currentPoint == null): return 0
	# move unit forward in our direction
	unit.translate(velocityVector * delta)
	checkIfReachedPoint()
	checkForCandy()
	return 1

# Check if we have reached our way point, then set the next target
func checkIfReachedPoint():
	if (targetPoint == null): return true
	var reachedPoint = false
	if (currentDirection == DIRECTION.NORTH && unit.transform.origin.z <= targetPoint.transform.origin.z):
		reachedPoint = true
	elif (currentDirection == DIRECTION.SOUTH && unit.transform.origin.z >= targetPoint.transform.origin.z):
		reachedPoint = true
	elif (currentDirection == DIRECTION.EAST && unit.transform.origin.x >= targetPoint.transform.origin.x):
		reachedPoint = true
	elif (currentDirection == DIRECTION.WEST && unit.transform.origin.x <= targetPoint.transform.origin.x):
		reachedPoint = true
		
	if (reachedPoint == true): setNewPoint(targetPoint)
	return reachedPoint


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#TODO: remove this, since it should be triggered by higher function, only have it here for testing purposes
	onDoRun(delta)

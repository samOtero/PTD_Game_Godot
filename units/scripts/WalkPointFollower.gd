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
var directionVector
var velocityVector
var candyList
var eventsRegistered = false
var unitLeftEvent

enum DIRECTION { NORTH, SOUTH, EAST, WEST }


# Called when the node enters the scene tree for the first time.
func _ready():
	unit = owner
	
	# Getting a reference of our unit left event
	unitLeftEvent = owner.owner.get_node("Events/EventUnitLeft")
	
	#TODO: remove this, just using it for testing
	var startPoint = owner.owner.get_node("Path1/WalkPoint")
	reset(startPoint)
	
func reset(startPoint):
	initialPoint = startPoint
	#set our location to the starting point
	unit.transform.origin = initialPoint.transform.origin
	#TODO: set these three from profile
	dontLeave = false
	canCaptureCandy = true
	freeRoam = false
	turnedAround = false #reset turned around as well
	directionVector = -Vector3.FORWARD
	velocityVector = directionVector * unit.currentSpeed
	setNewPoint(initialPoint)
	if (eventsRegistered == false):
		# TODO: Add run effect things here
		eventsRegistered = true
	
func setNewPoint(newPoint):
	currentPoint = newPoint
	targetPoint = GetTargetPoint(currentPoint)
	
	# Check to see if we got to the end
	if (targetPoint == null):
		# If we can turn around then we want to cycle
		if (!freeRoam && (dontLeave || !turnedAround)):
			turnedAround = !turnedAround
			targetPoint = GetTargetPoint(currentPoint)
		else:
			# If we reached our end
			# If we have candy then we want to capture it
			if (hasCandy):
				carriedCandy.onCaptured()
				hasCandy = false
				carriedCandy = null
			if (unitLeftEvent != null): unitLeftEvent.do_unit_left(unit)
			else: print('WalkPointFollower: MISSING unitLeftEvent!')
	getNewRotation(currentPoint, turnedAround)
	
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
	# TODO: Add checking for candy
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

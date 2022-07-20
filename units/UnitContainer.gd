extends Spatial

export var unitName = "0001_froggy"
var lifeBar
var totalLife
var currentLife
var lifePercent
var currentSpeed = 7.0 # TODO: Get this from profile and calculation
var isBattling
var isAlive
var id

var walkPointFollower

enum DIRECTION { NORTH, SOUTH, EAST, WEST }


# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO: This will probably move to Init since we won't know unitName until then
	# Add this units graphic to this container
	var unitScene = load("res://units/"+unitName+"_unit.tscn")
	var unitSceneInstance = unitScene.instance()
	add_child(unitSceneInstance)
	# Get life bar reference for unit, all units should have this set up
	lifeBar = get_node(unitName + "_unit/LifeBarUnit")
	# Initialize the life bar
	# TODO: should be based on profile eventually
	lifeBar.init(false, 100)
	totalLife = 100
	setLife(totalLife)
	doInit(null)


func doInit(_unitProfile):
	#TODO: set values based on given profile
	walkPointFollower = get_node("WalkPointFollower")
	isBattling = true # TODO: set this later, once we can drag towers
	isAlive = true
	id = 1 # should maybe come from global, but might be okay since we just want this unit object to be unique between pooling itself
	
func reset():
	setLife(totalLife)
	id += 1 # increase id since we are not the same unit
	#TODO: Add other things here

func setLife(newLife):
	currentLife = newLife
	doLifeChange()
	
func doLifeChange():
	lifePercent = (float(currentLife) / totalLife) * 100.0
	lifeBar._on_life_percent_change(lifePercent)
	
func takeDamage(howMuch: int, _fromWho: Spatial):
	if (isAlive == false): return 0
	#TODO: Add me to hit list here
	var newLife = currentLife - howMuch;
	if (newLife <= 0):
		onDefeat()
		return howMuch
	setLife(newLife)
	return howMuch

func onDefeat():
	setLife(0)
	isAlive = false
	# Try to Drop Candy
	if (walkPointFollower != null): walkPointFollower.dropCandy()
	#TODO: Give experience
	#TODO: Hide Unit?
	#TODO: Send unit defeated event
	queue_free()
	
func faceDirection(newDirection):
	var rotation = getRotationFromDirection(newDirection)
	# rotate our unit to face the new direction
	rotation_degrees = Vector3(0, rotation, 0)
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
	
func getID():
	return id

extends Spatial

export var unitName = "0001_froggy"
var lifeBar
var totalLife
var currentLife
var lifePercent
var currentSpeed = 4.0 # TODO: Get this from profile and calculation
var weakPercentRage = 20
var isBattling
var isAlive
var isHidding
var id

var walkPointFollower

# Stores the spot a tower is on, if any
var currentSpot

var unitMesh

# Events
export var unitCaptureEvent: Resource

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
	lifeBar.init(false, 100, weakPercentRage)
	totalLife = 100
	setLife(totalLife)
	
	#Get unit mesh
	unitMesh = get_node(unitName + "_unit/"+unitName + "_gfx/"+unitName)
	doInit(null)


func doInit(_unitProfile):
	#TODO: set values based on given profile
	walkPointFollower = get_node_or_null("WalkPointFollower")
	isBattling = true # TODO: set this later, once we can drag towers
	isAlive = true
	isHidding = false
	id = 1 # should maybe come from global, but might be okay since we just want this unit object to be unique between pooling itself
	
func _on_mouse_entered():
	unitCaptureEvent.do_hover_unit(self)
	
func _on_mouse_exited():
	unitCaptureEvent.do_exit_unit(self)

func setIsBattling(newIsBattling):
	isBattling = newIsBattling

func removeFromBattle():
	if (currentSpot != null): currentSpot.removeUnit(self)
	setIsBattling(false)
	currentSpot = null
	# TODO: Create a spot for towers to go when out of battle
	transform.origin = Vector3(0, 0, 0)

func reset():
	setLife(totalLife)
	id += 1 # increase id since we are not the same unit
	#TODO: Add other things here

func setLife(newLife):
	currentLife = newLife
	doLifeChange()
	
func isTargetable():
	return isAlive && !isHidding && isBattling;
	
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
	
func canCapture():
	# TODO: Check if we can even capture this unit
	if (lifePercent <= weakPercentRage): return true
	return false
	
func doCapture():
	if (canCapture() == false): return false
	# TODO: Factor some of this out to it's own thing
	onDefeat()
	# TODO: Send event for capturinig this unit
	return true
	
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
	
func doFade(newFade):
	if (newFade >= 1):
		# Fully show unit
		unitMesh.set_material_override(null)
	else:
		# Go to fade mode
		var originalMaterial = unitMesh.get_active_material(0)
		var material = SpatialMaterial.new()
		material.flags_transparent = true
		material.albedo_color = Color(1, 1, 1, newFade)
		material.albedo_texture = originalMaterial.albedo_texture
		unitMesh.set_material_override(material)

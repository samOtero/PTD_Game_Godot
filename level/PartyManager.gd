extends Node


var currentParty: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get spawn location for Unit
	# TODO: make this a location instead of adding it to this parent
	var spawnLocation = get_node("SpawnLocation")
	# Hardcode value for now
	var newProfile = UnitProfile.new()
	newProfile.unitID = 1
	newProfile.level = 5
	newProfile.nickname = "Froggy"
	newProfile.canCaptureMe = false
	newProfile.canCaptureCandy = false
	newProfile.freeRoam = false
	newProfile.attackSelected = 1
	newProfile.nonDamagingAttackOnly = false
	newProfile.modHP = 1
	# Add attack ids
	newProfile.attackIDs = [1]
	UnitProfile.GetBaseValues(newProfile)

	# Create the unit
	var unit = UnitProfile.CreateTower(newProfile, spawnLocation)

	# Create party container
	var newContainer = PartyContainer.new()
	newContainer.unit = unit
	newContainer.unitProfile = newProfile
	newContainer.hasBeenCreated = true

	# Add to the party object
	currentParty.append(newContainer)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

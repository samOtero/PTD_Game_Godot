extends Node

export var waveProfile: Resource
export var LevelEvents: Resource
var profile: UnitProfile
export var pathNum: int = 1
export var totalUnitsToSpawn: int
export var startDelay: int = 300
export var betweenDelay: int

var unitsLeftToSpawn: int
var counter: int
var isCompleted: bool
var isStarted: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	isCompleted = false
	isStarted = false
	counter = startDelay
	unitsLeftToSpawn = totalUnitsToSpawn
	# Get the unit profile from the child WaveProfile resource
	profile = waveProfile.getProfile()
	if (LevelEvents == null): print('WaveSegment: MISSING LevelEvents! Wont be able to spawn units in a path!')
	
func _onRun():
	if (isCompleted == true): return
	
	# Handle start delay if any
	if (isStarted == false):
		if (counter == 0):
			isStarted = true
			return
		counter -= 1
	
	# Check if we are done
	if (unitsLeftToSpawn == 0):
		isCompleted = true
		return
		
	# Once we count down then spawn the unit
	if (counter == 0):
		unitsLeftToSpawn -= 1
		counter = betweenDelay
		# Signal that we want to spawn
		LevelEvents.do_spawn_unit_in_path(profile, pathNum)
		return
	
	# Move the counter forward
	counter -= 1

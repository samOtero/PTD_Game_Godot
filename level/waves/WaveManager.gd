extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var path1Path: NodePath
export var RunEvent: Resource
var isCompleted: bool
var waveNum: int
var currentContainer: Node
var containerList: Array
var path1

var tempFlag = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to do_run signal from event
	var _error_code = RunEvent.connect("do_run", self, "_onRun")
	isCompleted = false
	waveNum = 1
	containerList = get_children()
	path1 = get_node(path1Path)
	# Connect to event signal
	var levelEvents = get_node("/root").get_node("GameRoot/Events/LevelEvents")
	if (levelEvents != null):
		levelEvents.connect("unit_left", self, "_on_Unit_Left_Event")
		levelEvents.connect("spawn_unit_in_path", self, "_onSpawnUnitInPath")
	else: print("WaveManager: MISSING levelEvents!")
	setContainer()
	
func setContainer():
	if (containerList.size() < waveNum):
		isCompleted = true
		return
	currentContainer = containerList[waveNum -1]
	
func _onSpawnUnitInPath(newProfile: UnitProfile, _pathNum: int):
	# TODO: Get path based on pathNum
	var path = path1;
	var newEnemy = UnitProfile.CreateEnemy(newProfile, owner)
	var wayPointFollower = newEnemy.get_node("WalkPointFollower")
	wayPointFollower.reset(path)
	
func _onRun(_delta):
	if (isCompleted == true): return
	if (currentContainer.isCompleted == true):
		waveNum += 1
		setContainer()
		return
	currentContainer._onRun()
	
		
func _on_Unit_Left_Event(whichUnit):
	# Remove from game
	#TODO: add object pooling here
	print("Received signal for unit left, removing from game!")
	whichUnit.queue_free()

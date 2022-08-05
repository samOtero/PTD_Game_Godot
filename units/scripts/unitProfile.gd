extends Node

class_name UnitProfile

var unitID: int
var resourceName: String
var nickname: String
var attackIDs: Array
var attackSelected: int
var level: int
var special: int

# Multiply inital HP by this to increase total HP, mainly used for enemy units
var modHP: int
var baseHP: int
var baseAttack: int
var baseSpAttack: int
var baseDefense: int
var baseSpDefense: int
var baseSpeed: float
var baseExperience: int
var currentExperience: int
var percentExperience: float

# If true, unit will leave the level after reaching the end of the path
var freeRoam: bool
var canCaptureCandy: bool
var canCaptureMe: bool
var elements: Array

#  If true, this unit can only use non damaging attacks, mainly used for enemy units
var nonDamagingAttackOnly: bool

# TODO: Make this global
enum ELEMENT_TYPE {
	NORMAL,
	FIRE,
	FIGHT,
	WATER,
	FLYING,
	GRASS,
	POISON,
	ELECTRIC,
	GROUND,
	PSYCHIC,
	ROCK,
	ICE,
	BUG,
	DRAGON,
	GHOST,
	DARK,
	STEEL,
	FAIRY
}


func _init(copyProfile = null):
	# We we send in a profile then we copy all it's relevant values
	if (copyProfile != null):
		unitID = copyProfile.unitID
		resourceName = copyProfile.resourceName
		nickname = copyProfile.nickname
		attackSelected = copyProfile.attackSelected
		level = copyProfile.level
		special = copyProfile.special
		modHP = copyProfile.modHP
		baseHP = copyProfile.baseHP
		baseAttack = copyProfile.baseAttack
		baseSpAttack = copyProfile.baseSpAttack
		baseDefense = copyProfile.baseDefense
		baseSpDefense = copyProfile.baseSpDefense
		baseSpeed = copyProfile.baseSpeed
		baseExperience = copyProfile.baseExperience
		freeRoam = copyProfile.freeRoam
		canCaptureCandy = copyProfile.canCaptureCandy
		nonDamagingAttackOnly = copyProfile.nonDamagingAttackOnly
		canCaptureMe = copyProfile.canCaptureMe
		if (copyProfile.elements == null):
			elements = []
		else:
			elements = copyProfile.elements.duplicate(true)
		if (copyProfile.attackIDs == null):
			attackIDs = []
		else:
			attackIDs = copyProfile.attackIDs.duplicate(true)
	
	currentExperience = 0
	percentExperience = 0.0

static func GetBaseInfo(whichUnitID: int) -> UnitBaseInfo:
	var baseInfo = UnitBaseInfo.new()
	match (whichUnitID):
		19:
			baseInfo.resourceName = "0019_ratty"
			baseInfo.elements = [ ELEMENT_TYPE.NORMAL ]
			baseInfo.baseHP = 30
			baseInfo.baseAttack = 56
			baseInfo.baseDefense = 35
			baseInfo.baseSpAttack = 25
			baseInfo.baseSpDefense = 35
			baseInfo.baseSpeed = 72
			baseInfo.baseExperience = 51
		1, _: # Default to froggy if not found
			baseInfo.resourceName = "0001_froggy"
			baseInfo.elements = [ ELEMENT_TYPE.GRASS, ELEMENT_TYPE.POISON ]
			baseInfo.baseHP = 45
			baseInfo.baseAttack = 49
			baseInfo.baseDefense = 49
			baseInfo.baseSpAttack = 65
			baseInfo.baseSpDefense = 65
			baseInfo.baseSpeed = 45
			baseInfo.baseExperience = 64
	return baseInfo
	
static func GetResourceName(whichUnitID: int) -> String:
	var baseInfo = GetBaseInfo(whichUnitID)
	return baseInfo.resourceName
	

static func GetBaseValues(profile) -> void:
	var baseInfo = GetBaseInfo(profile.unitID)
	profile.resourceName = baseInfo.resourceName
	profile.baseAttack = baseInfo.baseAttack
	profile.baseDefense = baseInfo.baseDefense
	profile.baseSpAttack = baseInfo.baseSpAttack
	profile.baseSpDefense = baseInfo.baseSpDefense
	profile.baseExperience = baseInfo.baseExperience
	profile.baseHP = baseInfo.baseHP
	profile.elements = baseInfo.elements
	# TODO: Speed once those are implemented better
	
static func CreateEnemy(newProfile, parentNode) -> Node:
	var containerScene = preload('res://units/UnitEnemyContainer.tscn')
	return CreateUnit(newProfile, containerScene, parentNode)
	
static func CreateUnit(newProfile, containerScene, parentNode) -> Node:
	var unitContainer = containerScene.instance()
	# Set our Unit Name so we can attach the correct graphic
	unitContainer.unitName = newProfile.resourceName
	# TODO: Add initilizing variables here
	parentNode.add_child(unitContainer)
	return unitContainer
	
	

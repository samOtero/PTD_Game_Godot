extends Resource
class_name WaveProfile


# This scene will create a profile that will be used by a wave segment

export var unitID: int
export var level: int
export var nickname: String
export var canCaptureMe: bool = true
export var attackSelected: int = 0
export var attack1Id: int
export var attack2Id: int = 0
export var attack3Id: int = 0
export var attack4Id: int = 0
export var modHP: int = 1
export var canCaptureCandy: bool = true
export var freeRoam: bool = false
export var nonDamagingAttacksOnly: bool = true
# Is the Unit regular = 0 shiny = 1, etc
export var special: int = 0
var newProfile

# TODO: Add more properties that we can modify here

# Returns Profile that is created from exported properties
func getProfile():
	if (newProfile != null): return newProfile
	# Init our profile based on given properties
	newProfile = UnitProfile.new()
	newProfile.unitID = unitID
	newProfile.level = level
	newProfile.nickname = nickname
	newProfile.canCaptureMe = canCaptureMe
	newProfile.canCaptureCandy = canCaptureCandy
	newProfile.freeRoam = freeRoam
	newProfile.attackSelected = attackSelected
	newProfile.nonDamagingAttackOnly = nonDamagingAttacksOnly
	newProfile.modHP = modHP
	# Add attack ids
	newProfile.attackIDs = [attack1Id]
	if (attack2Id != 0): newProfile.attackIDs.push_back(attack2Id)
	if (attack3Id != 0): newProfile.attackIDs.push_back(attack3Id)
	if (attack4Id != 0): newProfile.attackIDs.push_back(attack4Id)
	UnitProfile.GetBaseValues(newProfile)
	return newProfile

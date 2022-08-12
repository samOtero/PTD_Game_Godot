extends Node

export var RunEvent: Resource
var unit: Node
var attack1: Attack


# Called when the node enters the scene tree for the first time.
func _ready():
	unit = owner
	#TODO: Remove this
	unit.isBattling = true
	#TODO: set attack, this should be done via profile and attack initilization
	attack1 = Attack_Projectile.new(unit)
	add_child(attack1)
	
	# Connect to do_run signal from event
	var _error_code = RunEvent.connect("do_run", self, "_onRun")


func _onRun(_delta):
	attack1.runCooldown()
	if (unit.isBattling): attack1.doAttack()

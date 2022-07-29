extends Node

var unit: Node
var attack1: Attack


# Called when the node enters the scene tree for the first time.
func _ready():
	unit = owner
	#TODO: Remove this
	unit.isBattling = true
	#TODO: set attack, this should be done via profile and attack initilization
	attack1 = Attack_Damage.new(unit)
	add_child(attack1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#TODO: Remove this and connect to the event
	onDoRun()


func onDoRun():
	# TODO: Pause logic
	attack1.runCooldown()
	if (unit.isBattling): attack1.doAttack()

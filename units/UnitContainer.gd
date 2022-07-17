extends Spatial

export var unitName = "0001_froggy"
var lifeBar
var totalLife
var currentLife
var lifePercent


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


func doInit(_unitProfile):
	#TODO: set values based on given profile
	pass
	
func reset():
	setLife(totalLife)
	#TODO: Add other things here

func setLife(newLife):
	currentLife = newLife
	doLifeChange()
	
func doLifeChange():
	lifePercent = (float(currentLife) / totalLife) * 100.0
	lifeBar._on_life_percent_change(lifePercent)

extends Node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum DIRECTION { NORTH, SOUTH, EAST, WEST }
# Path identifier that waypoint belongs to
export(int) var pathId = 1
# Way points identifier, also sets order
export(int) var pointId = 1

export (DIRECTION) var forwardDirection
export (DIRECTION) var backwardDirection

export(NodePath) var nextPointPath
export(NodePath) var prevPointPath
var nextPoint
var prevPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	if (nextPointPath): nextPoint = get_node(nextPointPath)
	if (prevPointPath): prevPoint = get_node(prevPointPath)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

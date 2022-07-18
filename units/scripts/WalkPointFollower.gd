extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var unit
var currentDirection
var initialPoint
var currentPoint
var targetPoint
var turnedAround
var freeRoam
var dontLeave
var canCaptureCandy
var hasCandy
var carriedCandy
var directionVector
var candyList


# Called when the node enters the scene tree for the first time.
func _ready():
	unit = owner
	
func reset(startPoint):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var path1Path: NodePath
var path1

var tempFlag = false


# Called when the node enters the scene tree for the first time.
func _ready():
	path1 = get_node(path1Path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!tempFlag):
		tempFlag = true

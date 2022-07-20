extends Effect


# This effect base class for effects that have a target unit
class_name EffectForUnit

var target: Spatial
var fromWho: Spatial
var targetId: int

func _init(newTarget: Spatial, newFromWho: Spatial, newDelay: int = 0, newTag: String = "", newTag2: String = "").(newDelay, newTag, newTag2):
	target = newTarget
	fromWho = newFromWho
	targetId = target.getID()

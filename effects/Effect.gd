extends Node

class_name Effect

# Effects that will also run along side of this one
# but will end when this effect ends
var stackedEffects: Array

# Effects that will be initialized after this effect ends
var endEffects: Array

# Flag this effect to be removed
var needRemove: bool

# Flag to notify this effect that it has been paused
var isPaused: bool

# Delay timer for effect
# Making this a default feature for basic event to prevent having to add a timer effect
var delay: int

# Tags to identify the effect easier
var tag: String
var tag2: String

var container: Node

# Constructor
func _init(newDelay: int = 0, newTag: String = "", newTag2: String = ""):
	delay = newDelay
	tag = newTag
	tag2 = newTag2
	

func addToStack(newEffect):
	if (stackedEffects == null): stackedEffects = Array()
	stackedEffects.append(newEffect)
	
func addToEndStack(newEffect):
	if (endEffects == null): endEffects = Array()
	endEffects.append(newEffect)
	
func haveStackedEffects():
	return stackedEffects != null && stackedEffects.size() > 0
	
func doPause():
	isPaused = true
	doPauseCustom()
	if (haveStackedEffects()):
		for effect in stackedEffects:
			effect.doPause()
		
# Implement in subclasses			
func doPauseCustom():
	pass
	
func _on_doRun():
	if (needRemove == true): return
	
	if (delay > 0):
		delay -= 1
		return
	doRunCustom()
	if (haveStackedEffects()):
		for effect in stackedEffects:
			effect.doRun()
			
	if (needRemove == true):
		doRemove();
		
# Implement in subclasses	
func doRunCustom():
	pass
	
func doInit(newContainer: Node):
	container = newContainer
	# Add node to scene
	container.add_child(self)
	# Register to runEvent from container
	var error_code = container.connect("run_effects", self, "_on_doRun")
	if error_code != 0:
		print("ERROR: Effect -> doInit -> container.connect(): ", error_code)
	doInitCustom()
	if (haveStackedEffects()):
		for effect in stackedEffects:
			effect.doInit(newContainer)
		
# Implement in subclasses			
func doInitCustom():
	pass
	
func doCleanUp():
	needRemove = true
	doCleanUpCustom()
	if (haveStackedEffects()):
		for effect in stackedEffects:
			effect.doCleanUp()
		
# Implement in subclasses			
func doCleanUpCustom():
	pass
	
func doRemove():
	doRemoveCustom()
	if (haveStackedEffects()):
		for effect in stackedEffects:
			effect.doRemove()
	
	# Initilize our end effects
	if (endEffects != null && endEffects.size() > 0):
		for effect in endEffects:
			effect.doInit(container)
			
	# Remove Effect
	destroyEffect()
		
# Implement in subclasses			
func doRemoveCustom():
	pass

# Remove effect from scene
func destroyEffect():
	#TODO: pooling
	queue_free()

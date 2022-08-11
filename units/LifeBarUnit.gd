extends Spatial

export var lifePercent = 100
export var weakStyle: Resource
export var nonCatchableStyle: Resource
export var isNonCatchable = false
export var weakRange = 20
var progressBar
var foreground
var isInit = false


# Called when the node enters the scene tree for the first time.
# Set up our progress bar and foreground references
func _ready():
	progressBar = get_node("Viewport/ProgressBar")
	foreground = progressBar.get("theme").get_stylebox("fg", "ProgressBar")
	# Initializing at 100 percent but this could change
	lifePercent = 100;
	update_life_bar()

# Init our lifebar with the unit's initial values
func init(initialIsNonCatchable, newLifePercent, newWeakRange):
	isNonCatchable = initialIsNonCatchable
	weakRange = newWeakRange
	# Set the blue color for non catchable units
	if (isNonCatchable):
		progressBar.add_stylebox_override("fg", nonCatchableStyle)
	set_life_percent(newLifePercent)
	isInit = true
	
# Update life bar percent and color
func update_life_bar():
	progressBar.value = lifePercent
	# If our life is full then don't show life bar
	if (lifePercent >= 100):
		progressBar.visible = false
		return
	progressBar.visible = true
	if (isNonCatchable == false):
		if (lifePercent <= weakRange):
			progressBar.add_stylebox_override("fg", weakStyle)
		
	
# Set a new life percent and update bar
func set_life_percent(newLifePercent):
	lifePercent = newLifePercent
	update_life_bar()

# Called when a unit's life percent changes
func _on_life_percent_change(newLifePercent):
	set_life_percent(newLifePercent)

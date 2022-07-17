extends Spatial

export var lifePercent = 100
export var weakColor = Color(0.86, 0.03, 0.07, 1)
export var nonCatchableColor = Color(0.23, 0.26, 0.91, 1)
export var isNonCatchable = false
export var weakRange = 50
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
func init(initialIsNonCatchable, newLifePercent):
	isNonCatchable = initialIsNonCatchable
	# Set the blue color for non catchable units
	if (isNonCatchable):
		foreground.set_bg_color(nonCatchableColor)
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
			foreground.set_bg_color(weakColor)
		
	
# Set a new life percent and update bar
func set_life_percent(newLifePercent):
	lifePercent = newLifePercent
	update_life_bar()

# Called when a unit's life percent changes
func _on_life_percent_change(newLifePercent):
	set_life_percent(newLifePercent)

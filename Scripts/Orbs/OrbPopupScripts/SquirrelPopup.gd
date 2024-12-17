extends OrbPopup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = "Sciurus carolinensus : Eastern Gray Squirrel"
	diet_label.text = "Omnivorous. Primarily consumes plant matter"
	reproduction_label.text = "Females potentially have 2 litters a year, with litters containing 1 to 4 young"
	text = "Eastern gray squirrels are native to the eastern section of North America, but they have spread "
	text += "across the world. They are a common sight in many locations from forests to bustling cities. "
	text += "Squirrels collect a variety of plant matter to store in caches for later consumption."
	description_label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

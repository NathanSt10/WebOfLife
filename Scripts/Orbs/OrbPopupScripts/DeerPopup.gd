extends OrbPopup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = "Odocoileus virginianus : White-tailed deer"
	diet_label.text = "Herbivorous. Mainly eats woody shoots and stems"
	reproduction_label.text = "A doe typically gives birth to 1 to 3 fawns a year"
	text = "The white-tailed deer is present throughout a majority of North America. "
	text += "The white-tailed deer possess a multi-chambered stomach that allows them "
	text += "to eat foods that humans are unable to consume. They are almost exclusively "
	text += "herbivores, but may consume meat or bones if the need arises. Deer are a common target "
	text += "of hunters who may hunt them for sustenance or sport."
	description_label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

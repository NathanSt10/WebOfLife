class_name FoxPopup extends OrbPopup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = "Vulpes vulpes : Red Fox"
	diet_label.text = "Omnivorous. Primarily hunts rodents"
	reproduction_label.text = "Litters of 4 to 6 a year"
	text = "The red fox has lived successfully across the globe, and Wisconsin is no exception. "
	text += "Their incredible senses allow them to hunt small prey during Wisconsin winters. "
	text += "During the breeding season, foxes tend to stay in and around a burrow to raise their young. "
	text += "Foxes can thrive in many environments, and they have played important roles in human history."
	description_label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

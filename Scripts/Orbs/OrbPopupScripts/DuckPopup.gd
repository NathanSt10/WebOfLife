extends OrbPopup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = "Anas platyrhynchos : Mallard"
	diet_label.text = "Omnivorous. Diet consists of aquatic flora and fauna"
	reproduction_label.text = "A female lays 8 to 13 eggs a year that typically hatch during spring"
	text = "The mallard is a dabbling duck found in the northern hemisphere, though they are capable "
	text += "of thriving in diverse environments. While mallards eat animal matter, they primarily consume "
	text += "plant matter. This is especially the case during autumn migration and winter. Foxes are the "
	text += "main predators of mallards."
	description_label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

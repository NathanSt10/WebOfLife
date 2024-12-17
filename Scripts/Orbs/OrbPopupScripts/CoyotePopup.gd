class_name CoyotePopup extends OrbPopup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = "Canis Latrans : Coyote"
	diet_label.text = "Omnivorous. Primarily hunts deer"
	reproduction_label.text = "Litters of 6 each year"
	text = "An incredibly adaptable species, the coyote can be found throughout Wisconsin. "
	text += "Coyotes serve as one of Wisconsin's apex predators. " 
	text += "A coyote's diet ranges from deer hunted in packs to plant matter, and they are known "
	text += "to eat carrion. Their versatile diet may explain their presence in numerous environments "
	text += "around the world."
	description_label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

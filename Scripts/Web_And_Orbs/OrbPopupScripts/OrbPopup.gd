class_name OrbPopup extends Node3D

@onready var orb: Orb = $".."

@onready var name_label: Label = $SubViewport/Control/Panel/NameLabel
@onready var diet_label: Label = $SubViewport/Control/Panel/DietLabel
@onready var reproduction_label: Label = $SubViewport/Control/Panel/ReproductionLabel
@onready var description_label: Label = $SubViewport/Control/Panel/DescriptionLabel

var text

func initialize():
	pass
#Add rotation logic here
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#I'm hardcoding this since it isn't working properly
	if(orb.animalName == "coyote"):
		name_label.text = "Canis Latrans : Coyote"
		diet_label.text = "Diet: Omnivorous. Primarily hunts deer"
		reproduction_label.text = "Reproduction: Litters of 6 each year"
		text = "An incredibly adaptable species, the coyote can be found throughout Wisconsin. "
		text += "Coyotes serve as one of Wisconsin's apex predators. " 
		text += "A coyote's diet ranges from deer hunted in packs to plant matter, and they are known "
		text += "to eat carrion. Their versatile diet may explain their presence in numerous environments "
		text += "around the world."
		description_label.text = text
	elif(orb.animalName == "fox"):
		name_label.text = "Vulpes vulpes : Red Fox"
		diet_label.text = "Diet: Omnivorous. Primarily hunts rodents"
		reproduction_label.text = "Reproduction: Litters of 4 to 6 a year"
		text = "The red fox has lived successfully across the globe, and Wisconsin is no exception. "
		text += "Their incredible senses allow them to hunt small prey during Wisconsin winters. "
		text += "During the breeding season, foxes tend to stay in and around a burrow to raise their young. "
		text += "Foxes can thrive in many environments, and they have played important roles in human history."
		description_label.text = text
	elif(orb.animalName == "deer"):
		name_label.text = "Odocoileus virginianus : White-tailed deer"
		diet_label.text = "Diet: Herbivorous. Mainly eats woody shoots and stems"
		reproduction_label.text = "Reproduction: A doe typically gives birth to 1 to 3 fawns a year"
		text = "The white-tailed deer is present throughout a majority of North America. "
		text += "The white-tailed deer possess a multi-chambered stomach that allows them "
		text += "to eat foods that humans are unable to consume. They are almost exclusively "
		text += "herbivores, but may consume meat or bones if the need arises. Deer are a common target "
		text += "of hunters who may hunt them for sustenance or sport."
		description_label.text = text
	elif(orb.animalName == "duck"):
		name_label.text = "Anas platyrhynchos : Mallard"
		diet_label.text = "Diet: Omnivorous. Diet consists of aquatic flora and fauna"
		reproduction_label.text = "Reproduction: A female lays 8 to 13 eggs a year that typically hatch during spring"
		text = "The mallard is a dabbling duck found in the northern hemisphere, though they are capable "
		text += "of thriving in diverse environments. While mallards eat animal matter, they primarily consume "
		text += "plant matter. This is especially the case during autumn migration and winter. Foxes are the "
		text += "main predators of mallards."
		description_label.text = text
	elif(orb.animalName == "squirrel"):
		name_label.text = "Sciurus carolinensus : Eastern Gray Squirrel"
		diet_label.text = "Diet: Omnivorous. Primarily consumes plant matter"
		reproduction_label.text = "Reproduction: Females potentially have 2 litters a year, with litters containing 1 to 4 young"
		text = "Eastern gray squirrels are native to the eastern section of North America, but they have spread "
		text += "across the world. They are a common sight in many locations from forests to bustling cities. "
		text += "Squirrels collect a variety of plant matter to store in caches for later consumption."
		description_label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var max = max(get_parent().scale, 3)
	position = Vector3(0, max, 0)

class_name OrbPopup extends Node3D

@onready var name_label: Label = $SubViewport/Control/Panel/NameLabel
@onready var diet_label: Label = $SubViewport/Control/Panel/DietLabel
@onready var reproduction_label: Label = $SubViewport/Control/Panel/ReproductionLabel
@onready var description_label: Label = $SubViewport/Control/Panel/DescriptionLabel

var text

#Add rotation logic here
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

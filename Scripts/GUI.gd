extends Node3D

@onready var display_mesh: MeshInstance3D = $DisplayMesh
@onready var orb_1_label: Label = $SubViewport/Control/Panel/VBoxContainer/HBoxContainer/Orb1Label
@onready var orb_2_label: Label = $SubViewport/Control/Panel/VBoxContainer/HBoxContainer/Orb2Label
@onready var web_handler: Node3D = $"../../WebHandler"
@onready var button_1: MeshInstance3D = $Button1 
@onready var button_2: MeshInstance3D = $Button2

var textHolder = ""

signal togglePlay
signal resetSimulation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_1.buttonInput.connect(handleButton)
	button_2.buttonInput.connect(handleButton)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for animal in web_handler.webDict:
		if(web_handler.webDict[animal] != null):
			if(animal == "Orb1"):
				orb_1_label.visible = true
				textHolder = "Orb 1 \n"
				textHolder = textHolder + str(web_handler.webDict[animal].population)
				orb_1_label.text = textHolder
			elif(animal == "Orb2"):
				orb_2_label.visible = true
				textHolder = "Orb 2 \n"
				textHolder = textHolder + str(web_handler.webDict[animal].population)
				orb_2_label.text = textHolder
		else:
			if(animal ==  "Orb1"):
				orb_1_label.visible = false
			elif(animal == "Orb2"):
				orb_2_label.visible = false
			
func handleButton(button : Node3D):
	if(button == button_1): #pause
		print("Button 1")
		togglePlay.emit()
	elif(button == button_2): #reset
		print("Button 2")
		resetSimulation.emit()
	

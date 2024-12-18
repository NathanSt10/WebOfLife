extends Node3D

@onready var xr_origin_3d: XROrigin3D = $"../XROrigin3D"

@onready var display_mesh: MeshInstance3D = $GUIGrabBar/DisplayMesh
@onready var instruction_label: Label = $GUIGrabBar/SubViewport/Control/Panel/InstructionLabel
@onready var coyote_label: Label = $GUIGrabBar/SubViewport/Control/Panel/CoyoteLabel
@onready var fox_label: Label = $GUIGrabBar/SubViewport/Control/Panel/FoxLabel
@onready var deer_label: Label = $GUIGrabBar/SubViewport/Control/Panel/DeerLabel
@onready var duck_label: Label = $GUIGrabBar/SubViewport/Control/Panel/DuckLabel
@onready var squirrel_label: Label = $GUIGrabBar/SubViewport/Control/Panel/SquirrelLabel

@onready var web_handler: Node3D = $"../Web"
@onready var button_1: MeshInstance3D = $GUIGrabBar/Button1
@onready var button_2: MeshInstance3D = $GUIGrabBar/Button2
@onready var button_3: MeshInstance3D = $GUIGrabBar/Button3

var textHolder = ""
var angleToUser = 0.0

signal togglePlay
signal resetSimulation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_1.buttonInput.connect(handleButton)
	button_2.buttonInput.connect(handleButton)
	button_3.buttonInput.connect(handleButton)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("xr: ", xr_origin_3d)
	look_at(xr_origin_3d.global_position,Vector3(0,1,0),true)
	for animal in web_handler.webDict:
		if(web_handler.webDict[animal] != null):
			match animal:
				"coyote":
					coyote_label.visible = true
					textHolder = "Coyote\n"
					textHolder = textHolder + str(web_handler.webDict[animal].population)
					coyote_label.text = textHolder
				"fox":
					fox_label.visible = true
					textHolder = "Fox\n"
					textHolder = textHolder + str(web_handler.webDict[animal].population)
					fox_label.text = textHolder
				"deer":
					deer_label.visible = true
					textHolder = "Deer\n"
					textHolder = textHolder + str(web_handler.webDict[animal].population)
					deer_label.text = textHolder
				"duck":
					duck_label.visible = true
					textHolder = "Duck\n"
					textHolder = textHolder + str(web_handler.webDict[animal].population)
					duck_label.text = textHolder
				"squirrel":
					squirrel_label.visible = true
					textHolder = "Squirrel\n"
					textHolder = textHolder + str(web_handler.webDict[animal].population)
					squirrel_label.text = textHolder
		else:
			match animal:
				"coyote":
					coyote_label.visible = false
				"fox":
					fox_label.visible = false
				"deer":
					deer_label.visible = false
				"duck":
					duck_label.visible =false
				"squirrel":
					squirrel_label.visible = false

			
func handleButton(button : Node3D):
	if(button == button_1): #pause
		togglePlay.emit()
	elif(button == button_2): #reset
		resetSimulation.emit()
	elif(button == button_3):
		instruction_label.visible = !instruction_label.visible
		
	

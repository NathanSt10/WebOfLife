extends Node3D

@onready var orb_1: Orb = $Orb1
@onready var orb_2: Orb = $Orb2

var webDict = {"Orb1" : null,
			   "Orb2" : null}
			
var frameInterval = 5.0
var timeElapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Initialize this in a method/signal call. When an orb is placed, reparent into web and add reference
	orb_1.inPosition.connect(_orb_in_position)
	orb_2.inPosition.connect(_orb_in_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeElapsed += delta
	if(timeElapsed > frameInterval):
		timeElapsed = 0.0
		updateWeb()
	
func updateWeb():
	for animal in webDict: #This is just getting the string identifier. Keep this in mind
		
		if (webDict[animal] != null):
			#Orb 1
			if (webDict[animal] == webDict["Orb1"]): #Change this to use animal name in orb
				if (webDict["Orb2"] != null and webDict["Orb2"].population > 0): #Something to eat
					webDict["Orb2"].population -= webDict[animal].population
					if(webDict["Orb2"].population < 0): #Extinction event
						webDict[animal].population += webDict["Orb2"].population
						webDict["Orb2"].population = 0
					else:
						webDict[animal].population += webDict[animal].population/2
				else: #Decrement population by a flat amount. Can be modified later
					webDict[animal].population -= 50
					if(webDict[animal].population < 0):
						webDict[animal].population = 0
				print("Orb1: " + str(webDict[animal].population))
			#Orb 2
			elif (webDict[animal] == webDict["Orb2"]):
				if(webDict[animal].population > 1):
					webDict[animal].population += webDict[animal].population/2
				print("Orb2: " + str(webDict[animal].population))
func _orb_in_position(animalName : String, orbRef : Node3D):
	webDict[animalName] = orbRef
	print(animalName)
			

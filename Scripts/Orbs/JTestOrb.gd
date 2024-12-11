class_name Orb extends Node3D

@export var animalName = "default"
@export var goalLoc = Vector3(0.0,0.5,-1.0) #Possibly set this in a handler 
var moved = true #Change this to true when the orb is moved or placed. Change to false after locking in
var lastPos = Vector3(0.0,0.0,0.0)
var initialPopulation = 200
var population
var lastScale = 1.0 #To prevent constant updating. Could be handled with controllers I think

signal inPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	population = initialPopulation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#It's not exactly reaching the goalLoc. Just fix this in the handler.
	#Once position stops updating, send a signal that says it's done moving
	if(moved):
		global_position = global_position.slerp(goalLoc, 2*delta)
		if(global_position.distance_to(goalLoc) < 0.001): #Update this by adding an area3d that emits the signal when entered.
			moved = false
			lastPos = global_position
			inPosition.emit(animalName, self)
	else:
		moved = (lastPos == global_position)
		lastPos = global_position
		
	#Scale handling
	if(lastScale != global_scale):
		#Scale should be the same for all values, so this is a work around
		if(scale.x > 0.9 and scale.x < 1.1):
			initialPopulation = 200
		elif(scale.x > 1.1 and scale.x < 1.5):
			initialPopulation = 300
		elif(scale.x >= 1.5 and scale.x < 2.0):
			initialPopulation = 500
		elif(scale.x > 2.0):
			initialPopulation = 700
		elif(scale.x < 0.9 and scale.x > 0.5):
			initialPopulation = 100
		elif(scale.x > 0.0 and scale.x <= 0.5):
			initialPopulation = 50
	lastScale = global_scale
	
	
	

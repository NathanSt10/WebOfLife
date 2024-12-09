class_name Orb extends Node3D

@export var animalName = "default"
@export var goalLoc = Vector3(0.0,0.5,-1.0) #Possibly set this in a handler 
var moved = true #Change this to true when the orb is moved or placed. Change to false after locking in
@export var initialPopulation = 100
var population

signal inPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	population = initialPopulation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#It's not exactly reaching the goalLoc. Just fix this in the handler.
	#Once position stops updating, send a signal that says it's done moving
	if(moved):
		var lastPos = global_position
		global_position = global_position.slerp(goalLoc, 2*delta)
		if(global_position.distance_to(goalLoc) < 0.001): #Update this by adding an area3d that emits the signal when entered.
			moved = false
			inPosition.emit(animalName, self)
	
	

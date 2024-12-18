class_name Orb extends Node3D

@onready var orb_animal_popup: Node3D = $OrbAnimalPopup

@export var animalName = "default"
@export var goalLoc = Vector3(0.0,0.5,-1.0) #Possibly set this in a handler
@export var initialLoc = Vector3(0.0,1.0,2.0)
var preyList= []
var moved = false #Change this to true when the orb is moved or placed. Change to false after locking in
var lastPos = Vector3(0.0,0.0,0.0) # set in ready
var initialPopulation = 10000
var population
var lastScale = 1.0 #To prevent constant updating. Could be handled with controllers I think
var grabbed # Used to stop orb from trying to shift back in place while being grabbed

@onready var controllers = get_tree().get_nodes_in_group("controllers")

signal inPosition
signal orbMoved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	population = initialPopulation
	lastPos = global_position
	for controller in controllers:
		controller.get_child(0).grabbed.connect(_on_grabbed)
		controller.get_child(0).released.connect(_on_released)
		controller.get_child(0).highlight.connect(highlight)


func _on_grabbed(orb):
	if orb == self:
		print("Orb grabbed!")
		grabbed = true


func _on_released(orb):
	if orb == self:
		print("Orb released!")
		grabbed = false


func highlight(orb, isHighlighted):
	if orb == self:
		$Highlight.visible = isHighlighted
		orb_animal_popup.visible = isHighlighted

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#It's not exactly reaching the goalLoc. Just fix this in the handler.
	#Once position stops updating, send a signal that says it's done moving
	if moved and grabbed:
		#print("Moved is true, globalPos: %s" % global_position)
		global_position = global_position.slerp(goalLoc, 2*delta)
		if global_position.distance_to(goalLoc) < 0.001: #Update this by adding an area3d that emits the signal when entered.
			moved = false
			global_position = goalLoc
			lastPos = goalLoc
			print("Emit inPosition")
			print("Animal Name: %s, Self: %s" % [animalName, self])
			inPosition.emit(animalName, self)
	elif not grabbed:
		#print("Moved is false, lastPos: %s, globalPos: %s" % [lastPos, global_position])
		print("Moved: %s" % moved)
		moved = !(lastPos == global_position)
		if moved:
			print("Emit orbMoved")
			orbMoved.emit(animalName, self)
		lastPos = global_position
		
	#Scale handling
	if lastScale != scale.x:
		#Scale should be the same for all values, so this is a work around
		if(scale.x > 0.9 and scale.x < 1.2):
			initialPopulation = 10000
		elif(scale.x > 1.2 and scale.x < 1.5):
			initialPopulation = 12500
		elif(scale.x >= 1.5 and scale.x < 2.0):
			initialPopulation = 15000
		elif(scale.x > 2.0):
			initialPopulation = 17500
		elif(scale.x < 0.9 and scale.x > 0.5):
			initialPopulation = 7500
		elif(scale.x > 0.0 and scale.x <= 0.5):
			initialPopulation = 5000
	lastScale = scale.x
	orb_animal_popup.position.x = scale.x 
	orb_animal_popup.position.y = scale.x

class_name Orb extends Node3D

@export var animalName = "default"
@export var goalLoc = Vector3(0.0,0.5,-1.0) #Possibly set this in a handler 
var moved = false #Change this to true when the orb is moved or placed. Change to false after locking in
var lastPos = Vector3(0.0,0.0,0.0)
var initialPopulation = 200
var population
var lastScale = 1.0 #To prevent constant updating. Could be handled with controllers I think

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
		#show_highlight()


func _on_released(orb):
	if orb == self:
		print("Orb released!")
		#hide_highlight()

func show_highlight():
	print("Highlighting the orb: %s" % animalName)
	$Highlight.visible = true


func hide_highlight():
	print("Unhighlighting the orb: %s" % animalName)
	$Highlight.visible = false


func highlight(orb, isHighlighted):
	if orb == self:
		$Highlight.visible = isHighlighted

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#It's not exactly reaching the goalLoc. Just fix this in the handler.
	#Once position stops updating, send a signal that says it's done moving
	if(moved):
		#print("Moved is true, globalPos: %s" % global_position)
		global_position = global_position.slerp(goalLoc, 2*delta)
		if(global_position.distance_to(goalLoc) < 0.001): #Update this by adding an area3d that emits the signal when entered.
			moved = false
			global_position = goalLoc
			lastPos = goalLoc
			print("Emit inPosition")
			print("Animal Name: %s, Self: %s" % [animalName, self])
			inPosition.emit(animalName, self)
	else:
		#print("Moved is false, lastPos: %s, globalPos: %s" % [lastPos, global_position])
		moved = !(lastPos == global_position)
		if(moved):
			print("Emit orbMoved")
			orbMoved.emit(animalName, self)
		lastPos = global_position
		
	#Scale handling
	if(lastScale != scale.x):
		#Scale should be the same for all values, so this is a work around
		if(scale.x > 0.9 and scale.x < 1.2):
			initialPopulation = 200
		elif(scale.x > 1.2 and scale.x < 1.5):
			initialPopulation = 300
		elif(scale.x >= 1.5 and scale.x < 2.0):
			initialPopulation = 500
		elif(scale.x > 2.0):
			initialPopulation = 700
		elif(scale.x < 0.9 and scale.x > 0.5):
			initialPopulation = 100
		elif(scale.x > 0.0 and scale.x <= 0.5):
			initialPopulation = 50
	lastScale = scale.x

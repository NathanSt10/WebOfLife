extends Node3D

var line_renderer = preload("res://Scripts/Orbs/LineRenderer.gd")
@onready var coyote = $"CoyoteOrb"
@onready var fox = $"FoxOrb"
@onready var deer: MeshInstance3D = $DeerOrb
@onready var duck: MeshInstance3D = $DuckOrb
@onready var squirrel: MeshInstance3D = $SquirrelOrb
@onready var gui: Node3D = $"../WorldEnvironment/Gui"

var webDict = {"coyote" : null, "fox" : null, "deer" : null, "duck" : null, "squirrel" : null}

#Simulation variables
var frameInterval = 5.0 #Time between simulation frames
var timeElapsed = 0.0
var playSimulation = false

func _ready() -> void:
	var predator_list = [coyote, fox]
	for predator in predator_list:
		create_orb_thread(predator) 
	coyote.inPosition.connect(orbInPosition)
	fox.inPosition.connect(orbInPosition)
	deer.inPosition.connect(orbInPosition)
	duck.inPosition.connect(orbInPosition)
	squirrel.inPosition.connect(orbInPosition)
	gui.togglePlay.connect(onTogglePlay)
	gui.resetSimulation.connect(onResetSimulation)

func _process(delta: float) -> void:
	update_threads()
	if(playSimulation):
		timeElapsed += delta
		if(timeElapsed > frameInterval):
			timeElapsed = 0.0
			updateWeb()

#Simulation Notes
#Predators: A predator will attempt a hunt. If it fails, it will starve.
#Coyotes: Predator. Grow by population * 3 when population > 1
#60% hunt deer, and a single deer feeds 2. 15% hunt squirrels. 10% hunt ducks. 15% scavenge
#Foxes: Predator. Grow population by population * 5/2 when population > 1
#50% hunt squirrels, 25% hunt ducks, 25% scavenge
#Possibly include coyote related deaths
#Deer: Prey. Grow population by population / 2
#Duck: Prey. Grow population by population * 10/2, or population * 5
#Squirrel: Prey. Grow population by population * 3/2
func updateWeb():
	for animal in webDict:
		if(webDict[animal] != null):
			match animal:
				"coyote":
					var hungryAnimals = webDict[animal].population
					if(webDict["deer"] != null and webDict["deer"].population > 0):
						var toEat = floor((webDict[animal].population * 0.6) / 2)
						webDict["deer"].population -= toEat
						hungryAnimals -= toEat
						if(webDict["deer"].population < 0):
							hungryAnimals += webDict["deer"].population * 2
							webDict["deer"].population = 0
					if(webDict["duck"] != null and webDict["duck"].population > 0):
						var toEat = floor(webDict[animal].population * 0.1)
						webDict["duck"].population -= toEat 
						hungryAnimals -= toEat
						if(webDict["duck"].population < 0):
							hungryAnimals += webDict["duck"].population
							webDict["duck"].population = 0
					if(webDict["squirrel"] != null and webDict["squirrel"].population > 0):
						var toEat = floor(webDict[animal].population * 0.15)
						webDict["squirrel"].population -= toEat
						hungryAnimals -= toEat
						if(webDict["squirrel"].population < 0):
							hungryAnimals += webDict["squirrel"].population
							webDict["squirrel"].population = 0
					var toEat = floor(webDict[animal].population * 0.15)
					hungryAnimals -= toEat
					webDict[animal].population -= hungryAnimals
					webDict[animal].population += ceil(webDict[animal].population * 3)
				"fox":
					var hungryAnimals = webDict[animal].population
					if(webDict["duck"] != null and webDict["duck"].population > 0):
						var toEat = floor(webDict[animal].population * 0.25)
						webDict["duck"].population -= toEat 
						hungryAnimals -= toEat
						if(webDict["duck"].population < 0):
							hungryAnimals += webDict["duck"].population
							webDict["duck"].population = 0
					if(webDict["squirrel"] != null and webDict["squirrel"].population > 0):
						var toEat = floor(webDict[animal].population * 0.5)
						webDict["squirrel"].population -= toEat
						hungryAnimals -= toEat
						if(webDict["squirrel"].population < 0):
							hungryAnimals += webDict["squirrel"].population
							webDict["squirrel"].population = 0
					var toEat = floor(webDict[animal].population * 0.25)
					hungryAnimals -= toEat
					webDict[animal].population -= hungryAnimals
					webDict[animal].population += ceil(webDict[animal].population * (5/2))
				"deer":
					if(webDict[animal].population > 1):
						webDict[animal].population += ceil(webDict[animal].population / 2)
				"duck":
					if(webDict[animal].population > 1):
						webDict[animal].population += ceil(webDict[animal].population * 5)
				"squirrel":
					if(webDict[animal].population > 1):
						webDict[animal].population += ceil(webDict[animal].population * (3/2))

func orbInPosition(animalName : String, orb : Node3D):
	webDict[animalName] = orb
	#Add connection logic here. Toggle visibility of all connections from this node and to this node.
	#May be difficult, but I think it's possible. Refer to how connections are updated using metadata

func onTogglePlay():
	playSimulation = !playSimulation
	
func onResetSimulation():
	for animal in webDict:
		if(webDict[animal] != null):
			webDict[animal].population = webDict[animal].initialPopulation
			
# Threads (rendered MeshInstances connecting two orbs) are children of the prey
# Prey is currently just every node in the web
# This *should*/could run in a for loop where each iteration is a predetermined connection of the animal
func create_orb_thread(predator): 
	var prey_list = get_children()
	for prey in prey_list:
		if predator == prey: continue
		
		# Create raycast whose parent is a prey and will point its predator
		# upon update_threads() being called
		var prey_raycast_to_predator = RayCast3D.new()
		prey_raycast_to_predator.collide_with_areas = true
		prey_raycast_to_predator.collide_with_bodies = false
		prey.add_child(prey_raycast_to_predator)
		
		# Create raycast whose parent is a predator and will point to its prey
		# upon update_threads() being called
		var predator_raycast_to_prey = RayCast3D.new()
		predator_raycast_to_prey.collide_with_areas = true
		predator_raycast_to_prey.collide_with_bodies = false
		predator.add_child(predator_raycast_to_prey)
		
		# Create a thread whose parent is prey
		var thread_instance = MeshInstance3D.new()
		thread_instance.mesh = ImmediateMesh.new()
		thread_instance.set_script(line_renderer)
		thread_instance.set_meta("target_orb", predator)
		thread_instance.set_meta("preys_raycast", prey_raycast_to_predator)
		thread_instance.set_meta("predators_raycast", predator_raycast_to_prey)
		prey.add_child(thread_instance)



# THINK OF ANIMAL AS PREY 
# because currently every animal in the web is treated as prey to each predator
func update_threads():
	var animal_list = get_children()
	for animal in animal_list:
		for thread in animal.get_children():
			if thread is not MeshInstance3D: continue
			
			var thread_connection = thread.get_meta("target_orb")
			
			# Raycast of predator pointing to prey
			var predator_raycast_to_animal = thread.get_meta("predators_raycast")
			
			# Raycast of prey pointing to predator
			var animal_raycast_to_predator = thread.get_meta("preys_raycast")
			
			# Setting destination of raycasts
			predator_raycast_to_animal.target_position = animal.global_position - thread_connection.global_position
			animal_raycast_to_predator.target_position = thread_connection.global_position - animal.global_position
			
			# Setting points of thread generation
			thread.points[0] = predator_raycast_to_animal.get_collision_point()
			thread.points[1] = animal_raycast_to_predator.get_collision_point()

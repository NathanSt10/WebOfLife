extends Node3D

var line_renderer = preload("res://Scripts/Web_And_Orbs/LineRenderer.gd")
@onready var coyote = $"../Shelf/CoyoteOrb"
@onready var fox = $"../Shelf/FoxOrb"
@onready var deer: MeshInstance3D = $"../Shelf/DeerOrb"
@onready var duck: MeshInstance3D = $"../Shelf/DuckOrb"
@onready var squirrel: MeshInstance3D = $"../Shelf/SquirrelOrb"
@onready var gui: Node3D = $"../Gui"

var webDict = {"coyote" : null, "fox" : null, "deer" : null, "duck" : null, "squirrel" : null}

@onready var relationships = {
	"deer": {"predators": [fox, coyote], "prey": []},
	"fox": {"predators": [coyote], "prey": [deer, squirrel, duck]},
	"squirrel": {"predators": [fox, coyote], "prey": []},
	"duck": {"predators": [fox, coyote], "prey": []},
	"coyote": {"predators": [], "prey": [deer, fox]}
}

#Simulation variables
var frameInterval = 5.0 #Time between simulation frames
var timeElapsed = 0.0
var playSimulation = false

func _ready() -> void:
	coyote.inPosition.connect(orbInPosition)
	fox.inPosition.connect(orbInPosition)
	deer.inPosition.connect(orbInPosition)
	duck.inPosition.connect(orbInPosition)
	squirrel.inPosition.connect(orbInPosition)
	#gui.togglePlay.connect(onTogglePlay)
	#gui.resetSimulation.connect(onResetSimulation)

func _process(delta: float) -> void:
	create_orb_threads()
	update_threads()
	if(playSimulation):
		timeElapsed += delta
		if(timeElapsed > frameInterval):
			timeElapsed = 0.0
			updateWeb()

func is_predator(animal_name):
	if relationships.has(animal_name):
		return not relationships[animal_name]["prey"].is_empty()

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
						webDict[animal].population += ceil(webDict[animal].population * 4)
				"squirrel":
					if(webDict[animal].population > 1):
						webDict[animal].population += ceil(webDict[animal].population * (3/2))


func orbInPosition(animalName : String, orb : Node3D):
	print("Orb in Position")
	if orb.get_parent_node_3d() != self:
		print("Reparenting %s to %s. Its previous parent was %s" % [orb.name, self.name, orb.get_parent_node_3d().name])
		orb.get_parent_node_3d().remove_child(orb)
		self.add_child(orb)
	#create_orb_thread(orb)
	webDict[animalName] = orb
	print("%s (%s) added to webDict" % [webDict[animalName].name, orb.name])
	#Add connection logic here. Toggle visibility of all connections from this node and to this node.
	#May be difficult, but I think it's possible. Refer to how connections are updated using metadata


func onTogglePlay():
	playSimulation = !playSimulation


func onResetSimulation():
	for animal in webDict:
		if(webDict[animal] != null):
			webDict[animal].population = webDict[animal].initialPopulation


func create_orb_threads():
	for predator_name in relationships.keys():
		var predator = webDict[predator_name]
		print("predator from webDict: %s" % webDict[predator_name])
		if predator == null or not is_predator(predator_name):
			continue # Skip if predator is not in the web or not a predator
		print("Predator (%s) in web" % predator.animalName)
		for prey in relationships[predator_name]["prey"]:
			if webDict[prey.animalName] == null:
				continue # Skip if prey is not in the web
			
			if prey.has_node("%s_thread" % predator_name):
				continue
			
			var predator_raycast = RayCast3D.new()
			predator_raycast.name = "%s_raycast" % prey.animalName
			predator_raycast.collide_with_areas = true
			predator_raycast.collide_with_bodies = false
			predator.add_child(predator_raycast)
			
			var prey_raycast = RayCast3D.new()
			prey_raycast.name = "%s_raycast" % predator_name
			prey_raycast.collide_with_areas = true
			prey_raycast.collide_with_bodies = false
			prey.add_child(prey_raycast)
			
			var thread_instance = MeshInstance3D.new()
			thread_instance.mesh = ImmediateMesh.new()
			thread_instance.set_script(line_renderer)
			thread_instance.name = "%s_thread" % predator_name
			prey.add_child(thread_instance) # Child is parent of thread connection


func update_threads():
	for predator_name in relationships.keys():
		var predator = webDict[predator_name]
		if predator == null or not is_predator((predator_name)):
			continue # Skip if predator is not in the web or not a predator
		
		for prey in relationships[predator_name]["prey"]:
			if webDict[prey.animalName] == null:
				continue # Skip if prey is not in the web
			
			# Get raycasts
			var predator_raycast = predator.get_node_or_null("./%s_raycast" % prey.animalName)
			var prey_raycast = prey.get_node_or_null("./%s_raycast" % predator_name)
			if predator_raycast == null or prey_raycast == null:
				continue
			
			predator_raycast.target_position = prey.global_position - predator.global_position
			prey_raycast.target_position = predator.global_position - prey.global_position
			
			var thread = prey.get_node_or_null("./%s_thread" % predator_name)
			if thread != null:
				thread.points[0] = predator_raycast.get_collision_point()
				thread.points[1] = prey_raycast.get_collision_point()

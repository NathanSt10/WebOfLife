extends Node3D

var line_renderer = preload("res://Scripts/Orbs/LineRenderer.gd")
@onready var coyote = $"CoyoteOrb"
@onready var fox = $"FoxOrb"

func _ready() -> void:
	var predator_list = [coyote, fox]
	for predator in predator_list:
		create_orb_thread(predator) 

func _process(delta: float) -> void:
	update_threads()


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
		if animal.name == "MultiplayerSynchronizer": continue
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

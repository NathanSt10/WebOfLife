extends Node3D

var line_renderer = preload("res://Scripts/Godview/LineRenderer.gd")
@onready var coyote = $"CoyoteOrb"
@onready var fox = $"FoxOrb"

func _ready() -> void:
	var animal_list = [coyote, fox]
	for animal in animal_list:
		create_orb_thread(animal) 

func _process(delta: float) -> void:
	update_threads()


# This should run in a for loop where each iteration is a predetermined connection of the animal
func create_orb_thread(animal): 
	# Need to find way to determine what connections to be made
	# Currently just makes a connection to every orb in the web
	var connection_list = get_children()
	for connection in connection_list:
		if animal == connection: continue
		var thread_instance = MeshInstance3D.new()
		thread_instance.mesh = ImmediateMesh.new()
		thread_instance.set_script(line_renderer)
		thread_instance.set_meta("target_orb", animal)
		
		var direction = (connection.global_position - coyote.global_position).normalized() # $CoyoteOrb should be animal_connection
		thread_instance.points[0] = animal.global_position + direction * 0.518
		thread_instance.points[1] = connection.global_position - direction * 0.518 # $CoyoteOrb should be animal_connection
		
		connection.add_child(thread_instance)

# Only updates thread owned by deer that goes to coyote
# Need to go through all orbs that exist
# Need to find way to update all threads on an orb
func update_threads():
	var animal_list = get_children()
	for animal in animal_list:
		#print("Cur Animal: ", animal.name)
		for thread in animal.get_children():
			if thread is not MeshInstance3D: continue
			var thread_connection = thread.get_meta("target_orb")
			#print(thread_connection.name)
			var direction = (thread_connection.global_position - animal.global_position).normalized()
			thread.points[0] = animal.global_position + direction * 0.518
			thread.points[1] = thread_connection.global_position - direction * 0.518
			

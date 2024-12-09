extends XRController3D

#var left_controller_model = preload("res://Models/Quest2Controllers/OculusQuest2TouchController_Left.gltf")
#var right_controller_model = preload("res://Models/Quest2Controllers/OculusQuest2TouchController_Right.gltf")

#var highlighted_collider = null
var selected = null
@onready var controllers = get_tree().get_nodes_in_group("controllers")

# Currently not used
var offset = 0
var resetJoystick: bool = true

func _ready() -> void:
	print("Flashlight Technique Ready")

# Sets quest 2 models to the correct hand
func initialize():
	print("Flashlight reinitialized")


func _process(delta: float) -> void:
	pass


func _on_function_pickup_has_picked_up(what: Variant) -> void:
	if what:
		print("%s grabbed" % what.name)
		selected = what
		what.find_child("Duck").scale = Vector3(0.5, 0.5, 0.5)
		selected.find_child("Duck").scale = Vector3(0.5, 0.5, 0.5)  # Scale down the picked-up object
		print("Child: ", selected.find_child("Duck"))
		print("New scale after pickup: %s" % selected.scale)


func _on_function_pickup_has_dropped() -> void:
	if selected:
		selected.process_mode = Node.PROCESS_MODE_INHERIT  # Re-enable processing
		selected.scale = Vector3(2, 2, 2)  # Reset scale
		print("Object dropped and scaled back: %s" % selected.scale)
		selected = null

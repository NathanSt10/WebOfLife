extends XRController3D

var active_selection = null # Currently selected object
var active_selection_pos = null # Original position of selected object
var prev_selection = null
var cur_selected = null
var selections_list
var offset = 0
var resetJoystick: bool = true
var left_controller_model = preload("res://Models/Quest2Controllers/OculusQuest2TouchController_Left.gltf")
var right_controller_model = preload("res://Models/Quest2Controllers/OculusQuest2TouchController_Right.gltf")

var highlighted_collider: MeshInstance3D
var selected: MeshInstance3D
@onready var controllers = get_tree().get_nodes_in_group("controllers")


func _ready() -> void:
	print("Flashlight Technique Ready")


func initialize():
	active_selection = null
	active_selection_pos = null
	prev_selection = null
	cur_selected = null
	selections_list = []
	offset = 0
	resetJoystick = true
	var left_controller_model_scene = left_controller_model.instantiate()
	var right_controller_model_scene = right_controller_model.instantiate()
	left_controller_model_scene.global_rotation = Vector3(0,deg_to_rad(180),0)
	right_controller_model_scene.global_rotation = Vector3(0,deg_to_rad(180),0)
	left_controller_model_scene.position = Vector3(0,0,.035)
	right_controller_model_scene.position = Vector3(0,0,.035)
	if get_parent().is_left: add_child(left_controller_model_scene)
	else: add_child(right_controller_model_scene)
	print("Flashlight reinitialized")



func _process(delta: float) -> void:
	if controllers[0].get_child(0).name == "Flashlight":
		if $"ShapeCast3D".is_colliding():
			highlighted_collider = $"ShapeCast3D".get_collider(0).get_parent()
			print("colliding with %s" % $"ShapeCast3D".get_collider(0).get_parent().name)
			highlighted_collider.scale = Vector3(1.1, 1.1, 1.1)
		elif highlighted_collider and !selected:
			print("There was a collider but now there isnt")
			highlighted_collider.scale = Vector3(1, 1, 1)
			highlighted_collider = null
			
		if selected:
			update_selection_position()


func enable_selection():
	print("enable selection")
	# Enable shapecast and make controllers visible
	var controllers = get_tree().get_nodes_in_group("controllers")
	if controllers[0].get_child(0).name == "Flashlight":
		print("%s controller is flashlight" % controllers[0])
		controllers[0].get_child(0).find_child("ShapeCast3D").enabled = true
		controllers[0].get_child(0).visible = true
	if controllers[1].get_child(0).name == "Flashlight":
		print("%s controller is flashlight" % controllers[1])
		controllers[1].get_child(0).find_child("ShapeCast3D").enabled = true
		controllers[1].get_child(0).visible = true
	
	selected.scale = Vector3(1, 1, 1)
	selected.global_position = selected.get_meta("original_position")

func disable_selection():
	print("disable selection")
	# Disable shapcecast and make controllers invisible
	if controllers[0].get_child(0).name == "Flashlight":
		print("%s controller is flashlight" % controllers[0])
		controllers[0].get_child(0).find_child("ShapeCast3D").enabled = false
		controllers[0].get_child(0).visible = false
	if controllers[1].get_child(0).name == "Flashlight":
		print("%s controller is flashlight" % controllers[1])
		controllers[1].get_child(0).find_child("ShapeCast3D").enabled = false
		controllers[1].get_child(0).visible = false
	
	print("setting scale to .5")
	selected.scale = Vector3(0.5, 0.5, 0.5)


func update_selection_position():
	print("Updating selected position")
	selected.global_position = global_position


func _on_button_pressed(name: String) -> void:
	if name == "grip_click" and highlighted_collider:
		print("grip clicked")
		selected = highlighted_collider
		selected.set_meta("original_position", highlighted_collider.global_position)
		disable_selection()


func _on_button_released(name: String) -> void:
	if name == "grip_click" and selected:
		print("Grip released")
		enable_selection()
		selected = null

func _on_input_vector_2_changed(name: String, value: Vector2) -> void:
	if value.y > 0.8 and resetJoystick:
		offset += 1
		resetJoystick = false
	if value.y < -0.8 and resetJoystick:
		offset -= 1
		resetJoystick = false
	if value.y > -0.1 and value.y < 0.1:
		resetJoystick = true

extends XRController3D

var left_controller_model = preload("res://Models/Quest2Controllers/OculusQuest2TouchController_Left.gltf")
var right_controller_model = preload("res://Models/Quest2Controllers/OculusQuest2TouchController_Right.gltf")

var highlighted_collider: MeshInstance3D
var selected: MeshInstance3D
@onready var controllers = get_tree().get_nodes_in_group("controllers")

@onready var area_3d: Area3D = $Area3D

signal grabbed(orb)
signal released(orb)
signal highlight(orb, isHighlighted)

func _ready() -> void:
	print("Flashlight Technique Ready")
	if controllers[1].is_left:
		controllers[1].connect("controller_switched", _on_left_controller_switched)
		controllers[0].connect("controller_switched", _on_right_controller_switched)
	else:
		controllers[1].connect("controller_switched", _on_right_controller_switched)
		controllers[0].connect("controller_switched", _on_left_controller_switched)

# Sets quest 2 models to the correct hand
func initialize():
	if get_parent().is_left: 
		var left_controller_model_scene = left_controller_model.instantiate()
		left_controller_model_scene.global_rotation = Vector3(0,deg_to_rad(180),0)
		left_controller_model_scene.position = Vector3(0,0,.035)
		add_child(left_controller_model_scene)
	else: 
		var right_controller_model_scene = right_controller_model.instantiate()
		right_controller_model_scene.global_rotation = Vector3(0,deg_to_rad(180),0)
		right_controller_model_scene.position = Vector3(0,0,.035)
		add_child(right_controller_model_scene)
	print("Flashlight reinitialized")

var prev
func _process(delta: float) -> void:
	if $"ShapeCast3D".is_colliding(): # Known bug to crash when swithcing between flashlight and bubble
		highlighted_collider = $"ShapeCast3D".get_collider(0).get_parent()
		if prev != highlighted_collider: highlight.emit(prev, false)
		highlight.emit(highlighted_collider, true)
		prev = highlighted_collider
	elif highlighted_collider != null and selected == null:
		highlight.emit(highlighted_collider, false)
		highlighted_collider = null
		
	if selected:
		update_selection_position()

# Enable shapecast and make controllers visible
func enable_selection():
	print("enable selection")
	var controllers = get_tree().get_nodes_in_group("controllers")
	if controllers[0].get_child(0).name == "Flashlight":
		print("%s controller is flashlight" % controllers[0])
		controllers[0].get_child(0).find_child("ShapeCast3D").enabled = true
		controllers[0].get_child(0).visible = true
		area_3d.monitorable = true
	if controllers[1].get_child(0).name == "Flashlight":
		print("%s controller is flashlight" % controllers[1])
		controllers[1].get_child(0).find_child("ShapeCast3D").enabled = true
		controllers[1].get_child(0).visible = true
		area_3d.monitorable = true
	
	selected.scale = Vector3(1, 1, 1)
	if "lastPos" in selected:
		selected.global_position = selected.lastPos

# Disable shapcecast and make controllers invisible
func disable_selection():
	print("disable selection")
	highlight.emit(selected, false)
	if controllers[0].get_child(0).name == "Flashlight":
		print("%s controller is flashlight" % controllers[0])
		controllers[0].get_child(0).find_child("ShapeCast3D").enabled = false
		controllers[0].get_child(0).visible = false
		area_3d.monitorable = false 
	if controllers[1].get_child(0).name == "Flashlight":
		print("%s controller is flashlight" % controllers[1])
		controllers[1].get_child(0).find_child("ShapeCast3D").enabled = false
		controllers[1].get_child(0).visible = false
		area_3d.monitorable = false
	
	print("setting scale to .5")
	selected.scale = Vector3(0.5, 0.5, 0.5)


func update_selection_position():
	#print("Updating selected position")
	selected.global_position = global_position


func _on_button_pressed(name: String) -> void:
	if name == "grip_click" and highlighted_collider:
		print("grip clicked")
		grabbed.emit(highlighted_collider)
		selected = highlighted_collider
		if "lastPos" in selected:
			selected.lastPos = highlighted_collider.global_position
		disable_selection()


func _on_button_released(name: String) -> void:
	if name == "grip_click" and selected:
		print("Grip released")
		released.emit(selected)
		enable_selection()
		
		# Very rudimentary way to 'add' orb to web, currently no confirmation, just grab and release
		if "moved" in selected:
			selected.moved = true 
		if "grabbed" in selected:
			selected.grabbed = true
		
		selected = null


func _on_left_controller_switched(controller_type: String, is_left: bool):
	print("Left Flashlight switched to Bubble")
	if selected:
		selected.scale = Vector3(1, 1, 1)
		enable_selection()
		selected = null
	if highlighted_collider:
		highlighted_collider.scale = Vector3(1, 1, 1)

func _on_right_controller_switched(controller_type: String, is_left: bool):
	print("Right Flashlight switched to Bubble")
	if selected:
		selected.scale = Vector3(1, 1, 1)
		enable_selection()
		selected = null
	if highlighted_collider:
		highlighted_collider.scale = Vector3(1, 1, 1)

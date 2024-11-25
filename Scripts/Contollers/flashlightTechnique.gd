extends XRController3D

var active_selection = null # Currently selected object
var active_selection_pos = null # Original position of selected object
var prev_selection = null
var cur_selected = null
var selections_list
var offset = 0
var resetJoystick: bool = true

func _ready() -> void:
	print("Flashlight Technique Ready")
	tracker = get_parent_node_3d().tracker


func initialize(new_tracker: String):
	tracker = new_tracker
	active_selection = null
	active_selection_pos = null
	prev_selection = null
	cur_selected = null
	selections_list = []
	offset = 0
	resetJoystick = true
	print("Flashlight reinitialized with tracker:", tracker)



func _process(delta: float) -> void:
	global_transform = get_parent_node_3d().global_transform
	var main_controller = get_parent_node_3d().get_parent_node_3d()
	$"ShapeCast3D".global_position = main_controller.global_position + Vector3(0,0,-14)
	$"ShapeCast3D".global_rotation = main_controller.global_rotation + Vector3(deg_to_rad(90),0,0)
	
	if $"ShapeCast3D".is_colliding():
		selections_list = $"ShapeCast3D".collision_result
		var closest = $"ShapeCast3D".get_collider(abs(offset) % selections_list.size()).get_parent()
		if active_selection == null or active_selection != closest:
			prev_selection = active_selection
			if prev_selection != null: prev_selection.scale = Vector3(1, 1, 1)
			active_selection = closest
			active_selection.scale = Vector3(1.1, 1.1, 1.1)
	elif active_selection != null:
		offset = 0
		active_selection.scale = Vector3(1,1,1)
		active_selection = null


func _on_button_pressed(name: String) -> void:
	if name == "grip_click":
		if active_selection != null:
			# Save the original position of the active selection
			active_selection_pos = active_selection.global_transform.origin
			
			# Move the selected object to the controller's position
			active_selection.global_transform.origin = global_transform.origin
			active_selection.scale = Vector3(0.5, 0.5, 0.5)
			cur_selected = active_selection


func _on_button_released(name: String) -> void:
	if name == "grip_click" and active_selection_pos != null:
		# Return the selected object to its original position
		cur_selected.global_transform.origin = active_selection_pos
		cur_selected.scale = Vector3(1, 1, 1)
		
		# Reset variables
		active_selection_pos = null
		cur_selected = null
		

func _on_input_vector_2_changed(name: String, value: Vector2) -> void:
	if value.y > 0.8 and resetJoystick:
		offset += 1
		resetJoystick = false
	if value.y < -0.8 and resetJoystick:
		offset -= 1
		resetJoystick = false
	if value.y > -0.1 and value.y < 0.1:
		resetJoystick = true

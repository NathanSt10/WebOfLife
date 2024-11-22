extends XRController3D

var active_selection = null
var active_selection_pos = null
var prev_selection = null
var cur_selected = null
var selections_list
var offset = 0
var resetJoystick: bool = true

func _ready() -> void:
	print("Flashlight Technique Ready")


func _process(delta: float) -> void:
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
			active_selection_pos = active_selection.position
			active_selection.position = global_position
			active_selection.scale = Vector3(0.5, 0.5, 0.5)
			cur_selected = active_selection


func _on_button_released(name: String) -> void:
	if name == "grip_click" and active_selection_pos != null:
		cur_selected.position = active_selection_pos 
		cur_selected.scale = Vector3(1, 1, 1)
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

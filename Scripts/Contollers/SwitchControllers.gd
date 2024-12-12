extends XRController3D

@export var jetpack_scene: PackedScene
@export var bubble_cursor_scene: PackedScene
@export var flashlight_scene: PackedScene

signal controller_switched(controller_type: String, is_left: bool)
@export var is_left: bool = false

var current_controller_type: String
var current_controller_instance: Node = get_child(0) as XRController3D

@onready var debugger = $"Debugger"

#var leftGrabbed
#var rightGrabbed
var initialDistanceBetweenHands: float
var currentDistanceBetweenHands: float
var scaleFactor = Vector3(1.0,1.0,1.0)
var initialScale = Vector3(1.0,1.0,1.0)
@export var max_scale: Vector3 = Vector3(2.0, 2.0, 2.0) # Maximum allowed scale

#@onready var right_hand: XRController3D = $"../RightController"
#@onready var left_hand: XRController3D = $"../LeftController"

var grabbed_object = null
var other_controller: XRController3D

func _ready() -> void:
	if name == "LeftController": is_left = true
	switch_to_controller("flashlight")
	print(name)
	other_controller = get_node("../LeftController" if name == "RightController" else "../RightController")


func _process(delta: float) -> void:
	if grabbed_object and grabbed_object == other_controller.grabbed_object:
		update_bimanual_scaling()

func grab_object(object):
	#debugger.play()
	grabbed_object = object
	if grabbed_object and grabbed_object == other_controller.grabbed_object:
		debugger.play()
		initialDistanceBetweenHands = global_position.distance_to(other_controller.global_position)
		initialScale = grabbed_object.scale


func update_bimanual_scaling():
	currentDistanceBetweenHands = global_position.distance_to(other_controller.global_position)
	scaleFactor = initialScale * (currentDistanceBetweenHands / initialDistanceBetweenHands)
	
	# Clamp the scale to the maximum allowed size
	scaleFactor.x = min(scaleFactor.x, max_scale.x)
	scaleFactor.y = min(scaleFactor.y, max_scale.y)
	scaleFactor.z = min(scaleFactor.z, max_scale.z)
	
	grabbed_object.scale = scaleFactor
	grabbed_object.set_meta("original_scale", grabbed_object.scale)
	# debugger.play()


func switch_to_controller(controller_type: String):
	if is_left:
		tracker = "left_hand"
	else:
		tracker = "right_hand"
	
	if current_controller_instance:
		current_controller_instance.queue_free()
		
	match controller_type:
		"bubble":
			current_controller_instance = bubble_cursor_scene.instantiate()
			current_controller_type = "bubble"
			print("Switching to " + current_controller_type + "...")
		"jetpack":
			current_controller_instance = jetpack_scene.instantiate()
			current_controller_type = "jetpack"
			print("Switching to " + current_controller_type + "...")
		"flashlight":
			current_controller_instance = flashlight_scene.instantiate()
			current_controller_type = "flashlight"
			print("Switching to " + current_controller_type + "...")
		_:
			return # Invalid controller type
		
	add_child(current_controller_instance)
	current_controller_instance.connect("object_grabbed", grab_object)
	#if current_controller_instance.has_method("set_grabbed_object"):
		#if is_left:
			#current_controller_instance.call("set_grabbed_object", leftGrabbed)
		#else:
			#current_controller_instance.call("set_grabbed_object", rightGrabbed)
	if current_controller_instance.has_method("initialize"):
		current_controller_instance.call("initialize")
	emit_signal("controller_switched", current_controller_type, is_left)
	# current_controller_instance.transform = Transform3D.IDENTITY


func _on_button_pressed(name: String) -> void:
	if (name == "ax_button"):
		if current_controller_type == "bubble":
			switch_to_controller("flashlight")
		elif current_controller_type == "flashlight":
			switch_to_controller("bubble")
		elif current_controller_type == "jetpack":
			switch_to_controller("flashlight")
	if (name == "by_button"):
		switch_to_controller("jetpack")
		
	if name == "grip_click":
		if current_controller_instance.has_method("_on_button_pressed"):
			current_controller_instance.call("_on_button_pressed", name)


func _on_button_released(name: String) -> void:
	if name == "grip_click":
		if current_controller_instance.has_method("_on_button_released"):
			current_controller_instance.call("_on_button_released", name)


func _on_input_vector_2_changed(name: String, value: Vector2) -> void:
	if current_controller_instance.has_method("_on_input_vector_2_changed"):
			current_controller_instance.call("_on_input_vector_2_changed", name, value)

func _on_input_float_changed(name: String, value: float) -> void:
	if current_controller_instance.has_method("_on_input_float_changed"):
		current_controller_instance.call("_on_input_float_changed", name, value)

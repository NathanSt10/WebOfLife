extends XRController3D

@export var jetpack_scene: PackedScene
@export var bubble_cursor_scene: PackedScene
@export var flashlight_scene: PackedScene

signal controller_switched(controller_type: String, is_left: bool)
@export var is_left: bool = false

var current_controller_type: String
var current_controller_instance: Node = get_child(0) as XRController3D

func _ready() -> void:
	switch_to_controller("flashlight")
	if name == "LeftController": is_left = true
	print(name)


func _process(delta: float) -> void:
	pass


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
	if current_controller_instance.has_method("initialize"):
		current_controller_instance.call("initialize", tracker)
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
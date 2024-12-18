extends XROrigin3D

@export var left_controller : XRController3D
@export var right_controller : XRController3D

@export var max_radius = 0.8
@export var min_radius = 0.0

enum ControllerMode { JETPACK, CURSOR, FLASHLIGHT }
@export var left_mode : ControllerMode = ControllerMode.FLASHLIGHT
@export var right_mode : ControllerMode = ControllerMode.FLASHLIGHT

var velocity_left = Vector3.ZERO
var velocity_right = Vector3.ZERO

@export var jetpack_speed = 5.0
@export var acceleration = 2.0
@export var deceleration = 5.0
@export var jetpack_button = "trigger"

var is_colliding = false
var collision_normal = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_controller = $"LeftController"
	right_controller = $"RightController"
	left_controller.connect("controller_switched", _on_controller_switched)
	right_controller.connect("controller_switched", _on_controller_switched)


func _on_controller_switched(controller_type: String, is_left: bool):
	if controller_type == "jetpack":
		if is_left:
			left_mode = ControllerMode.JETPACK
		else:
			right_mode = ControllerMode.JETPACK
	elif controller_type == "bubble":
		if is_left:
			left_mode = ControllerMode.CURSOR
		else:
			right_mode = ControllerMode.CURSOR
	elif controller_type == "flashlight":
		if is_left:
			left_mode = ControllerMode.FLASHLIGHT
		else:
			right_mode = ControllerMode.FLASHLIGHT


var collision_objects = []

func _process(delta: float) -> void:
	# Code provided by ChatGPT to provide "bouncy" feel
	if is_colliding:
		# Prevent moving further into the collision object
		var correction = Vector3.ZERO
		for area in collision_objects:
			if area and area.global_transform:  # Ensure area is valid
				var direction_to_object = (area.global_transform.origin - self.global_transform.origin).normalized()
				if velocity_left.dot(direction_to_object) > 0:
					correction -= direction_to_object * velocity_left.dot(direction_to_object)
				if velocity_right.dot(direction_to_object) > 0:
					correction -= direction_to_object * velocity_right.dot(direction_to_object)
		velocity_left += correction
		velocity_right += correction


	# Jetpack movement logic
	if left_mode == ControllerMode.JETPACK:
		if left_controller and left_controller.is_button_pressed(jetpack_button):
			var forward_direction = -left_controller.transform.basis.z.normalized()
			velocity_left += forward_direction * jetpack_speed * delta * acceleration
		else:
			velocity_left = velocity_left.lerp(Vector3.ZERO, deceleration * delta)
		self.global_transform.origin += velocity_left * delta

	if right_mode == ControllerMode.JETPACK:
		if right_controller and right_controller.is_button_pressed(jetpack_button):
			var forward_direction = -right_controller.transform.basis.z.normalized()
			velocity_right += forward_direction * jetpack_speed * delta * acceleration
		else:
			velocity_right = velocity_right.lerp(Vector3.ZERO, deceleration * delta)
		self.global_transform.origin += velocity_right * delta

	var total_velocity = (velocity_left + velocity_right).length()
	var normalized_speed = clamp(total_velocity / (jetpack_speed * 2), 0.0, 1.0)
	var vignette_size = lerp(min_radius, max_radius, normalized_speed)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area not in collision_objects:
		collision_objects.append(area)
	is_colliding = true

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area in collision_objects:
		collision_objects.erase(area)
	is_colliding = len(collision_objects) > 0

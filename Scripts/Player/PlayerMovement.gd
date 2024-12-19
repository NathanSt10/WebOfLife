extends XROrigin3D

@export var left_controller: XRController3D
@export var right_controller: XRController3D

enum ControllerMode { JETPACK, CURSOR, FLASHLIGHT }

@export var left_mode: ControllerMode = ControllerMode.FLASHLIGHT
@export var right_mode: ControllerMode = ControllerMode.FLASHLIGHT

@onready var cylinder = get_node("../Environment/Boundary")
@onready var cylinder_radius = cylinder.radius
@onready var cylinder_height = cylinder.height
@onready var cylinder_center = cylinder.global_transform.origin  # Use global position of the cylinder
@export var pull_strength: float = 10.0

var start_pos
var current_pos

var velocity_left = Vector3.ZERO
var velocity_right = Vector3.ZERO

@export var jetpack_speed = 5.0
@export var acceleration = 2.0
@export var deceleration = 5.0
@export var jetpack_button = "trigger"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_controller = $"LeftController"
	right_controller = $"RightController"
	start_pos = global_position

func _process(delta: float) -> void:
	# Jetpack movement for left controller
	if left_controller and left_controller.is_button_pressed(jetpack_button):
		var forward_direction = -left_controller.global_transform.basis.z.normalized()
		velocity_left += forward_direction * jetpack_speed * acceleration * delta
	else:
		velocity_left = velocity_left.lerp(Vector3.ZERO, deceleration * delta)

	# Jetpack movement for right controller
	if right_controller and right_controller.is_button_pressed(jetpack_button):
		var forward_direction = -right_controller.global_transform.basis.z.normalized()
		velocity_right += forward_direction * jetpack_speed * acceleration * delta
	else:
		velocity_right = velocity_right.lerp(Vector3.ZERO, deceleration * delta)

	var total_velocity = velocity_left + velocity_right

	# Update the current position
	current_pos = global_transform.origin + total_velocity * delta

	# Check horizontal bounds relative to the cylinder center
	var horizontal_offset = current_pos - cylinder_center
	horizontal_offset.y = 0  # Ignore the vertical offset
	var horizontal_distance = horizontal_offset.length()
	if horizontal_distance > cylinder_radius:
		horizontal_offset = horizontal_offset.normalized() * cylinder_radius
		current_pos.x = cylinder_center.x + horizontal_offset.x
		current_pos.z = cylinder_center.z + horizontal_offset.z

	# Clamp the position within the height of the cylinder
	if abs(current_pos.y - cylinder_center.y) > cylinder_height / 2:
		current_pos.y = clamp(current_pos.y, cylinder_center.y - cylinder_height / 2, cylinder_center.y + cylinder_height / 2)

	# Apply the final position
	global_transform.origin = current_pos

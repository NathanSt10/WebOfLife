extends XRController3D

# Reference to the XROrigin node
@export var xr_origin: XROrigin3D

# Jetpack settings
@export var jetpack_speed = 5.0
@export var acceleration = 10.0
@export var deceleration = 5.0
@export var jetpack_button = "trigger"  # Button to activate the jetpack

# Current velocity for jetpack movement
var velocity = Vector3.ZERO

func _process(delta):
	if xr_origin:
		handle_jetpack_movement(delta)

func handle_jetpack_movement(delta):
	# Check if the jetpack button is pressed
	if is_button_pressed(jetpack_button):
		# Get the forward direction based on this controller’s orientation
		var forward_direction = -transform.basis.z.normalized()

		# Accelerate in the forward direction
		velocity += forward_direction * jetpack_speed * delta * acceleration
	else:
		# Smooth deceleration when the button is released
		velocity = velocity.linear_interpolate(Vector3.ZERO, deceleration * delta)

	# Move the XROrigin based on the velocity
	xr_origin.global_transform.origin += velocity * delta

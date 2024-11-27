extends XRController3D

var grabbed = null
var last_pos
var max_radius = 0.1
var min_radius = 0.02
var initial_hitbox_radius = 0.04
var sphere: CSGSphere3D
var hitbox: CollisionShape3D
var area: Area3D  # Reference to the Area3D for detecting overlaps

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = global_position
	sphere = $CSGSphere3D
	hitbox = $CSGSphere3D/Area3D/CollisionShape3D
	hitbox.scale = Vector3.ONE
	area = $CSGSphere3D/Area3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grabbed != null:
		var delta_pos = global_position - last_pos
		grabbed.global_position += delta_pos
	last_pos = global_position
	
	# Get the number of overlapping areas
	var overlapping_areas = area.get_overlapping_areas()
	var overlap_count = overlapping_areas.size()

	# Adjust sphere size based on the number of overlapping areas
	if !grabbed:
		if overlap_count == 0 and sphere.radius < max_radius:
			# Grow the sphere when no areas are in contact
			sphere.radius += 0.0025
			hitbox.scale = Vector3.ONE * (sphere.radius / initial_hitbox_radius)
		elif overlap_count >= 2 and sphere.radius > min_radius:
			# Shrink the sphere when in contact with 2 or more areas
			sphere.radius -= 0.005
			hitbox.scale = Vector3.ONE * (sphere.radius / initial_hitbox_radius)
		# Do nothing if overlap_count is 1 (no growth or shrinkage)

func _on_input_float_changed(name: String, value: float) -> void:
	if name == "grip":
		# Recalculate overlap_count to ensure it’s in scope
		var overlapping_areas = area.get_overlapping_areas()
		var overlap_count = overlapping_areas.size()
		
		if grabbed == null and overlap_count > 0 and value >= 0.2:
			grabbed = overlapping_areas[0].get_parent()  # Grabs the first overlapping area
		elif grabbed != null and value < 0.2:
			grabbed = null

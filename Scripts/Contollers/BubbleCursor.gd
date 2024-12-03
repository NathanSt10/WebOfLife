extends XRController3D

var grabbed = null
var last_pos: Vector3
var max_radius = 0.1
var min_radius = 0.02
var initial_hitbox_radius = 0.04
var sphere: CSGSphere3D
var hitbox: CollisionShape3D
var area: Area3D  # Reference to the Area3D for detecting overlaps

@onready var grab_sound = $GrabSound

func _ready() -> void:
	last_pos = global_transform.origin
	sphere = $CSGSphere3D
	hitbox = $CSGSphere3D/Area3D/CollisionShape3D
	area = $CSGSphere3D/Area3D
	print("PARENT: " + get_parent().name)

func _process(delta: float) -> void:
	if grabbed != null:
		var delta_pos = global_position - last_pos
		grabbed.global_position += delta_pos
	last_pos = global_position

	# Get the number of overlapping areas
	var overlapping_areas = area.get_overlapping_areas()
	var overlap_count = overlapping_areas.size()

	# Adjust sphere size based on the number of overlapping areas
	if grabbed == null:
		if overlap_count == 0 and sphere.radius < max_radius:
			sphere.radius += 0.0025
			hitbox.scale = Vector3.ONE * (sphere.radius / initial_hitbox_radius)
		elif overlap_count >= 2 and sphere.radius > min_radius:
			sphere.radius -= 0.005
			hitbox.scale = Vector3.ONE * (sphere.radius / initial_hitbox_radius)

func _on_input_float_changed(name: String, value: float) -> void:
	if name == "grip":
		var overlapping_areas = area.get_overlapping_areas()
		if grabbed == null and overlapping_areas.size() > 0 and value >= 0.2:
			grabbed = overlapping_areas[0].get_parent()  # Grabs the first overlapping area
			# grabbed.scale = Vector3(0.5, 0.5, 0.5)
		elif grabbed != null and value < 0.2:
			# grabbed.scale = Vector3.ONE
			grabbed = null

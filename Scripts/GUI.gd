extends Node3D

@onready var display_mesh: MeshInstance3D = $DisplayMesh
@onready var v_box_container: VBoxContainer = $SubViewport/Control/Panel/VBoxContainer
@onready var web_handler: Node3D = $"../../WebHandler"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_mesh.get_surface_override_material(0).billboard_mode = BaseMaterial3D.BillboardMode.BILLBOARD_ENABLED
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

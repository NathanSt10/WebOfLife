extends Node

var main_scene = preload("res://Scenes/Main.tscn")
var network_controller_script = preload("res://Scripts/Network/NetworkController.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("entered")
	var scene = main_scene.instantiate()
	scene.set_script(network_controller_script)
	scene.set_process(true)
	scene.is_server = false
	if get_tree(): get_tree().root.add_child(scene)

extends Node

var main_scene = preload("res://Scenes/Main.tscn")
var network_controller_script = preload("res://Scripts/Network/NetworkController.gd")

const PORT = 6729


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("entered")
	var scene = main_scene.instantiate()
	scene.set_script(network_controller_script)
	scene.set_process(true)
	scene.is_server = true
	if get_tree(): get_tree().root.add_child(scene)
	upnp_setup()


func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	print("UPNP Port Mapping Result: ", map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())

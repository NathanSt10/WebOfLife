extends Node

var player_scene = preload("res://SceneInstances/Rig.tscn")

@export var is_server = false
@export var address = 0
const PORT = 6729

var rng = RandomNumberGenerator.new()
func gen_color(id: int) -> Color:
	rng.seed = id
	return (Color(rng.randf(), rng.randf(), rng.randf(), 0.5))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Network Setup")
	get_node("/root").remove_child(get_node("/root/Lobby"))
	
	if is_server:
		print("Starting Server")
		var peer = ENetMultiplayerPeer.new()
		peer.set_bind_ip("0.0.0.0")
		peer.create_server(PORT)
		multiplayer.multiplayer_peer = peer
		
		var player = player_scene.instantiate()
		player.set_process(true)
		player.get_child(3).material = StandardMaterial3D.new()
		player.get_child(3).material.albedo_color = gen_color(1)
		player.name = str(1)
		add_child(player)
		
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		
	else:
		print("Starting Client!")
		var peer = ENetMultiplayerPeer.new()
		print("Create client connected to %s" % address)
		peer.create_client(address, PORT) # Change localhost <-> address
		multiplayer.multiplayer_peer = peer
		
		var id = peer.get_unique_id()
		print("Client id: ", id)
		
		var player = player_scene.instantiate()
		player.set_process(true)
		player.get_child(3).material = StandardMaterial3D.new()
		player.get_child(3).material.albedo_color = gen_color(id)
		player.name = str(id)
		add_child(player)
		
		multiplayer.connected_to_server.connect(_on_connected_to_server)


func _process(delta: float) -> void:
	pass


func _on_peer_connected(id: int) -> void:
	print("A client connected to my server")
	var other_player = player_scene.instantiate()
	other_player.set_process(true)
	other_player.get_child(3).material = StandardMaterial3D.new()
	other_player.get_child(3).material.albedo_color = gen_color(id)
	other_player.name = str(id)
	add_child(other_player)


func _on_peer_disconnected(id: int) -> void:
	get_tree().root.find_child(str(id)).queue_free()


func _on_connected_to_server() -> void:
	var other_player = player_scene.instantiate()
	other_player.set_process(true)
	other_player.get_child(3).material = StandardMaterial3D.new()
	other_player.get_child(3).material.albedo_color = gen_color(1)
	other_player.name = str(1)
	add_child(other_player)

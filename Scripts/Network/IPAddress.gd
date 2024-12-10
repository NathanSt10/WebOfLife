extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Window":
		text = "Your IP Address is: %s" % IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")), 1)
	else:
		text = "Your IP Address is: %s" % IP.resolve_hostname(str(OS.get_environment("HOSTNAME")), 1) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

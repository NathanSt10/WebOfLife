extends Node3D

@onready var gui: Node3D = $"."
signal buttonInput
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func toggleButton():
	buttonInput.emit(self)
	#Add some visual feedback. This will need to be different for each button I think

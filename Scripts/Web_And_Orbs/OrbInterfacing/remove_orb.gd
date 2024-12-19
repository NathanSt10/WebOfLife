extends Node3D

var inArea = false
var orb

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if inArea:
		#orb.global_position = global_position


func _on_remove_area_entered(area: Area3D) -> void:
	$Orb/Highlight.visible = true
	#inArea = true
	#orb = area.get_parent()

func _on_remove_area_exited(area: Area3D) -> void:
	$Orb/Highlight.visible = false
	#inArea = false
	#orb = null

extends Node3D

@onready var gui: Node3D = $"."
@onready var button_highlight: MeshInstance3D = $Button1Highlight
var buttonHighlighted = false
var lockInput = false #Prevents signal from being sent without reselecting the button
var timeElapsed = 0.0
var toggleTime = 3.0
signal buttonInput
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#Selection input is mediocre at best. A queue could possibly be implemented to make it so toggling
#time can persist across hands, but it's incredibly unneccessary right now
func _process(delta: float) -> void:
	if(buttonHighlighted and !lockInput):
		timeElapsed += delta
		if(timeElapsed >= toggleTime):
			buttonInput.emit(self)
			lockInput = true
	
	
func _on_area_entered(area: Area3D):
	if(!buttonHighlighted):
		button_highlight.visible = true
		timeElapsed = 0.0
		buttonHighlighted = true
	
func _on_area_exited(area: Area3D):
	if(buttonHighlighted):
		button_highlight.visible = false
		timeElapsed = 0.0
		buttonHighlighted = false
		lockInput = false

extends Node3D

## Allows the user to scale the earth directly.
## Will scale about a point near the user.
##
## requires the scale of this transform is uniform.

@export var scale_factor: float = 1.01
@export var max_size: float = 5
@export var min_size: float = 0.2
var tolerance = 0.2

enum GrowState { GROWING, SHRINKING, NONE }
var state: GrowState = GrowState.NONE

# right joystick will grow / shrink the earth itself
func _on_right_controller_input_vector_2_changed(action_name: String, value: Vector2) -> void:
	if (action_name == "scale"):
		if (value.y < -tolerance):
			state = GrowState.SHRINKING
		elif (value.y > tolerance):
			state = GrowState.GROWING
		else:
			state = GrowState.NONE

func grow_earth() -> void:
	var new_scale: float = scale.x * scale_factor
	new_scale = clampf(new_scale, min_size, max_size)
	scale = Vector3(new_scale, new_scale, new_scale)

func shrink_earth() -> void:
	var new_scale: float = scale.x / scale_factor
	new_scale = clampf(new_scale, min_size, max_size)
	scale = Vector3(new_scale, new_scale, new_scale)
	
# each frame, grow earth if they are holding the joystick up and vice versa
func _process(_delta: float) -> void:
	
	match state:
		GrowState.GROWING:
			grow_earth()
		GrowState.SHRINKING:
			shrink_earth()
		
	return

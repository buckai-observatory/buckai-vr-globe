extends Node3D

@export var scale_factor: float = 1.1
@export var max_size: float = 5
@export var min_size: float = 0.2
@export var trigger_threshold: float = 0.8

enum GrowState { GROWING, SHRINKING, NONE }
var state: GrowState = GrowState.NONE



func _on_left_controller_button_pressed(action_name: String) -> void:
	if (action_name == "by_button"):
		print(state)
		print(XRServer.world_scale)
		print()

# left trigger will grow player
# earth will appear to get smaller
func _on_left_controller_input_float_changed(action_name: String, value: float) -> void:
	if (action_name == "trigger"):
		if (value > trigger_threshold):
			state = GrowState.GROWING
		else:
			state = GrowState.NONE

# right trigger will shrink player 
# earth will appear to get larger
func _on_right_controller_input_float_changed(action_name: String, value: float) -> void:
	if (action_name == "trigger"):
		if (value > trigger_threshold):
			state = GrowState.SHRINKING
		else:
			state = GrowState.NONE

func grow_player() -> void:
	var new_scale: float = XRServer.world_scale * scale_factor
	XRServer.world_scale = clampf(new_scale, min_size, max_size)

func shrink_player() -> void:
	var new_scale: float = XRServer.world_scale / scale_factor
	XRServer.world_scale = clampf(new_scale, min_size, max_size)
	
# each frame, grow player if they are holding the grow button and vice versa
func _process(_delta: float) -> void:
	
	match state:
		GrowState.GROWING:
			grow_player()
		GrowState.SHRINKING:
			shrink_player()
		
	return

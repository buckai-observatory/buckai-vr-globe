extends Node3D

@export var angular_velocity: float = 0.1

var tolerance = 0.2

enum HorizontalRotationState { LEFT, RIGHT, NONE }
var horizontal_state: HorizontalRotationState = HorizontalRotationState.NONE

enum VerticalRotationState { UP, DOWN, NONE }
var vertical_state: VerticalRotationState = VerticalRotationState.NONE

func _on_left_controller_input_vector_2_changed(action_name: String, value: Vector2) -> void:
	
	if (action_name == "rotate"):
		
		# set vertical state
		if (value.y < -tolerance):
			vertical_state = VerticalRotationState.DOWN
		elif (value.y > tolerance):
			vertical_state = VerticalRotationState.UP
		else:
			vertical_state = VerticalRotationState.NONE
			
		# set horizontal state
		if (value.x < -tolerance):
			horizontal_state = HorizontalRotationState.LEFT
		elif (value.x > tolerance):
			horizontal_state = HorizontalRotationState.RIGHT
		else:
			horizontal_state = HorizontalRotationState.NONE
	
	
func _on_left_controller_button_pressed(action_name: String) -> void:
	if (action_name == "realign_rotation"):

		var earth_up: Vector3 = transform.basis.y
		
		if (earth_up != Vector3.UP):
			var axis_to_rotate: Vector3 = earth_up.cross(Vector3.UP)
			var angle_to_rotate: float = acos(earth_up.dot(Vector3.UP))
			rotate(axis_to_rotate.normalized(), angle_to_rotate)


# each frame, rotate earth if the user is holding the joystick in a direction
func _process(_delta: float) -> void:
	
	# horizontal rotation can just be around the global y axis
	match horizontal_state:
		HorizontalRotationState.LEFT:
			rotate_y(-angular_velocity)
		HorizontalRotationState.RIGHT:
			rotate_y(angular_velocity)

	if (vertical_state != VerticalRotationState.NONE): 
		# not redundant to make the if check above
		# it saves us from getting the hmd transform every frame
		
		# need to handle vertical rotation with respect to the 
		# direction the user is facing 
		var hmd_transform: Transform3D = XRServer.get_hmd_transform()
		var hmd_right_axis: Vector3 = hmd_transform.basis.x
		
		match vertical_state:
			VerticalRotationState.DOWN:
				rotate(hmd_right_axis, angular_velocity)
			VerticalRotationState.UP:
				rotate(hmd_right_axis, -angular_velocity)
		
	return

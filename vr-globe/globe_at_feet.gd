extends MeshInstance3D

@export var zoom_multiplier: float = 1.1

# change scale based on y value of right joystick
func _on_right_hand_controller_input_vector_2_changed(action_name: String, value: Vector2) -> void:
	if (action_name == "primary"):
		# resting: value = (0, 0)
		# -1 <= value.y <= 1
		if (value.y < 0):
			scale /= zoom_multiplier
		elif (value.y > 0):
			scale *= zoom_multiplier

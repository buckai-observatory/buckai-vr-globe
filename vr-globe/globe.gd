extends MeshInstance3D

@export var zoom_multiplier: float = 2.0

const GLOBE_MIN_RADIUS: float = 0.25
const GLOBE_MAX_RADIUS: float = 5400

func _on_left_hand_controller_button_pressed(action_name: String) -> void:
	
	# zoom out, make globe smaller
	if (action_name == "ax_button"):
		scale /= zoom_multiplier
	
	# zoom in, make globe bigger	
	elif (action_name == "by_button"):
		if (scale.x * zoom_multiplier < GLOBE_MAX_RADIUS):
			scale *= zoom_multiplier

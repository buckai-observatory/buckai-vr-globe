extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_left_controller_button_pressed(action_name: String) -> void:
	if (action_name == "ax_button"):
		# go to "earth ahead" view
		
		rotate_object_local(Vector3.LEFT, deg_to_rad(90))
		print("rotated to AHEAD view")
		
		#change gravity
		$Globe/GlobeUnderfootOrigin/Gravity.gravity_space_override = 0 #DISABLE
		
		$Globe/PlaneGravity.transform = $XROrigin3D.transform
		
		$Globe/PlaneGravity.gravity_space_override = 3 #REPLACE
	
	elif (action_name == "by_button"):
		# go to "earth underfoot" view
		rotate_object_local(Vector3.LEFT, deg_to_rad(-90))
		print("rotated to UNDERFOOT view")
		
		$Globe/GlobeUnderfootOrigin/Gravity.gravity_space_override = 3 #REPLACE
		$Globe/PlaneGravity.gravity_space_override = 0 #DISABLE
		

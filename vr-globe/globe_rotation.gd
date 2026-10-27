extends Node3D

# user needs to be able to rotate the globe
enum GlobeState { AHEAD, UNDERFOOT, CHANGING, NONE }
	
var current_state: GlobeState = GlobeState.AHEAD
var future_state: GlobeState = GlobeState.NONE

var rotation_time: float = 0

func _on_right_controller_button_pressed(action_name: String) -> void:
	
	if (action_name == "ax_button"):
		
		match current_state:
			
			GlobeState.AHEAD:
				future_state = GlobeState.UNDERFOOT
				current_state = GlobeState.CHANGING
				
				rotation_time = 0
				
				$GlobeAheadOrigin/GlobeBody/SphereMesh.visible = false
				$GlobeUnderfootOrigin/GlobeBody/SphereMesh.visible = true
				
			GlobeState.UNDERFOOT:
				future_state = GlobeState.AHEAD
				current_state = GlobeState.CHANGING
				
				rotation_time = 0
				
				$GlobeAheadOrigin/GlobeBody/SphereMesh.visible = true
				$GlobeUnderfootOrigin/GlobeBody/SphereMesh.visible = false
		
		#TODO: remove once smooth interpolation is implemented
		current_state = future_state
		future_state = GlobeState.NONE
	
	return



#TODO: call this function for smooth interpolation later.
#for now, just have two copies of the earth and toggle between them 
func interpolate_earth_state(body: StaticBody3D, from: Node3D, to: Node3D, delta: float) -> void:
	
	rotation_time += delta
	if (rotation_time < 1):
		var q_from: Quaternion = Quaternion(from.transform.basis)
		var q_to: Quaternion = Quaternion(to.transform.basis)
	
		q_from = q_from.normalized()
		q_to = q_to.normalized()
	
		var q_interpolated: Quaternion = q_from.slerp(q_to, rotation_time)
		
		body.rotation = q_interpolated.get_euler()
		
	else: # done rotating
		body.transform = to.transform
		current_state = future_state
		future_state = GlobeState.NONE 
	
	return
	

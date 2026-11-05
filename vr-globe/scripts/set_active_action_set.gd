extends Node3D

var xr_interface: OpenXRInterface

var allowed_to_switch: bool = true

func _ready() -> void:
	xr_interface = XRServer.find_interface("OpenXR")


func _on_left_controller_button_pressed(action_name: String) -> void:
	
	if (allowed_to_switch):
			
		if (action_name == "ax_button"):
			
			allowed_to_switch = false
			$Timer.start(1)
			
			print("switching to earth control")
			xr_interface.set_action_set_active("godot", false)
			xr_interface.set_action_set_active("earth_control", true)
			
			
		elif (action_name == "switch_action_map"):
			
			allowed_to_switch = false
			$Timer.start(1)
			
			print("switching to locomotion")
			xr_interface.set_action_set_active("earth_control", false)
			xr_interface.set_action_set_active("godot", true)
			
	
func _on_timer_timeout() -> void:
	allowed_to_switch = true

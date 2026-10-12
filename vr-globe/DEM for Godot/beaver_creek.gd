extends Node3D

# compute positions from latitude and longitude

#TODO: figure out precision for floats
const latitude: float = 39.613361419896286;
const longitude: float = -106.53322343390212;

#TODO: worry about elevation precisely later
const radius: float = 1081.243

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#TODO look into how godot does spherical rotations, quaternions etc
	position.x = radius * cos(deg_to_rad(longitude)) * cos(deg_to_rad(latitude))
	position.y = radius * sin(deg_to_rad(latitude))
	position.z = -radius * sin(deg_to_rad(longitude)) * cos(deg_to_rad(latitude))
	
	#TODO rotate beaver creek properly
	

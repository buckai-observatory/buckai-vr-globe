extends Node3D

# compute positions from latitude and longitude

#precision for floats (to the thousanth)

@export var latitude: float = 39.613;
@export var longitude: float = -106.533;

#TODO: worry about elevation precisely later

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#TODO look into how godot does spherical rotations, quaternions etc
	#position.x = radius * cos(deg_to_rad(longitude)) * cos(deg_to_rad(latitude))
	#position.y = radius * sin(deg_to_rad(latitude))
	#position.z = -radius * sin(deg_to_rad(longitude)) * cos(deg_to_rad(latitude))
	
	#rotateToLatLong(latitude, longitude)
	return
	
func rotateToLatLong(lat: float, long: float) -> void:
	
	rotate_y(deg_to_rad(long))
	

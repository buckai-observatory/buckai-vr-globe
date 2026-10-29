@tool
extends Node3D

#latitude of 0 is Equator
@export var latitude: float = 0:
	set(new_latitude):
		latitude = new_latitude
		update_rotation(latitude, longitude)

# longitude of 0 is Prime Meridian
@export var longitude: float = 0:
	set(new_longitude):
		longitude = new_longitude
		update_rotation(latitude, longitude)
		
func update_rotation(lat: float, long: float) -> void:
	rotation = Vector3.ZERO
	rotate_y(deg_to_rad(long))
	rotate_object_local(Vector3.RIGHT, deg_to_rad(lat))
	
	print("latitude = " + str(lat))
	print("longitude = " + str(long))
	print()

@tool
extends Node3D

# This script is to be attached to an AOI object.
#
# If the AOI's origin is not at its center, give it a parent node and attach 
# this script to that node.
#
# This script should be the child of a ScaleDown1000 node, with scale = 0.001
# and position equal to (Equator, Prime Meridian) on the globe's surface

@export var aoi_width_in_mi_irl: float = 10:
	set(new_width_in_mi_irl):
		aoi_width_in_mi_irl = new_width_in_mi_irl
		update_scale()
		
@export var aoi_width_in_m_godot: float = 200:
	set(new_width_in_m_godot):
		aoi_width_in_m_godot = new_width_in_m_godot
		update_scale()
		
@export var globe_radius_in_m_godot: float = 50:
	set(new_globe_rad):
		globe_radius_in_m_godot = new_globe_rad
		update_scale()
		
# ASSUME Globe has radius 50 m Godot
# Earth average radius is 3963 mi irl
# ASSUME there is a parent ScaleDown1000 with scale = 0.001
func update_scale() -> void:
	
	var globe_radius_in_mi_irl: float = 3963
	
	var mi_irl_in_m_godot: float = globe_radius_in_mi_irl / globe_radius_in_m_godot
	
	var aoi_width_in_m_godot_earth: float = aoi_width_in_mi_irl / mi_irl_in_m_godot
	
	var m_godot_earth_per_m_godot_aoi: float = aoi_width_in_m_godot_earth / aoi_width_in_m_godot
	
	var scale_factor = m_godot_earth_per_m_godot_aoi * 1000
	scale = Vector3(scale_factor, scale_factor, scale_factor)

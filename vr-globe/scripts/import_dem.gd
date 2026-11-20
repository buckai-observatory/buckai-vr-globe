@tool
extends EditorScript

var file_folder: String = "res://DEM/"
var file_name: String = "beaver_creek_dem.png"

var created_mesh_multiplier: float = 0.1

func _run() :
	create_mesh()

func create_mesh():
	print("creating mesh")
	
	var file_path: String = file_folder + file_name
	var image: Image = load(file_path)
	
	# NOTE: The maximum image size is 16384×16384 pixels
	var image_width: int = image.get_width()
	var image_height: int = image.get_height()
	
	# format 1D array size: image_width * image_height * 4
	# each 4 elements correspond to 1 pixel RGBA
	var color_data: PackedByteArray = image.get_data()
	
	# grayscale means r = g = b. plus we don't care about a
	# so, we only need to sample every 4th point
	
	# TODO: better file format that doesn't store 4x as much data
	# as we need? Plus maybe more precion than [0, 255]?
	
	# each color (r, g, b, or a) is in range [0,255]
	
	# when producing this image, we did linear interpolation
	# range being min data value to max data value
	# beaver creek: [2167, 3705]
	
	# NOTE: precision lost due to this conversion to [0, 255] range
	
	var vertices: PackedVector3Array = PackedVector3Array()
	var normals: PackedVector3Array = PackedVector3Array()
	var indices: PackedInt32Array = PackedInt32Array()
	var uvs: PackedVector2Array = PackedVector2Array()
	
	var i: int = 0
	
	while (i < color_data.size()):
		
		@warning_ignore("integer_division")
		var vert_i: int = i / 4
		
		# image x -> Mesh x
		var col = vert_i % image_width
		var x_pos: float = col * created_mesh_multiplier
		
		# image y -> Mesh (z) # TODO: negative z?
		@warning_ignore("integer_division")
		var row = vert_i / image_width
		var z_pos: float = row * created_mesh_multiplier
		
		# image color -> Mesh y
		var elevation = color_data[i]
		# TODO: height scale is incorrect
		var y_pos: float = elevation * created_mesh_multiplier
		
		var vert: Vector3 = Vector3(x_pos, y_pos, z_pos)
		vertices.append(vert)
		
		# TODO: handle normals more intelligently
		normals.append(Vector3.UP)
		
		var u: float = float(col) / image_width
		var v: float = float(row) / image_height
		
		uvs.append(Vector2(u, v))
		
		if (row > 0 and col > 0):
			# indices stores triangles for the mesh as trios of vertex indices
			# indices is a 1D array, so each 3 elements correspond to a triangle
			
			# adding two triangles related to this "grid cell"
			# indices need to be in clockwise order
			indices.append_array([
				vert_i, 
				vert_i - 1, 
				vert_i - image_width - 1
			])
			indices.append_array([
				vert_i, 
				vert_i - image_width - 1,
				vert_i - image_width
			])
		
		# increment by 4 since r = g = b and a doesn't matter
		i += 4 

	
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	surface_array[Mesh.ARRAY_VERTEX] = vertices
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	var parent: Node3D = EditorInterface.get_edited_scene_root()
	var node: MeshInstance3D = MeshInstance3D.new()
	parent.add_child(node)
	
	node.mesh = ArrayMesh.new()
	
	node.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	ResourceSaver.save(node.mesh, "res://DEM/beaver_creek_mesh.tres", ResourceSaver.FLAG_COMPRESS)

	node.queue_free()

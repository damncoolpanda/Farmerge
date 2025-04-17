@tool
extends EditorPlugin

func _enter_tree():
	resource_saved.connect(_on_resource_saved)

func _on_resource_saved(resource):
	if resource is PackedScene:
		var model = resource
		var viewport = get_viewport().new()
		var camera = Camera3D.new()
		var light = OmniLight3D.new()
		
		viewport.add_child(camera)
		viewport.add_child(light)
		viewport.render_target_v_flip = true
		viewport.size = Vector2(64, 64)
		
		model.add_child(viewport)
		model.show()
		
		await get_tree().idle_frame
		await get_tree().idle_frame
		
		var image = viewport.get_texture().get_data()
		var thumbnail = ImageTexture.new()
		thumbnail.create_from_image(image)
		
		model.set("thumbnail/icon", thumbnail)
		model.remove_child(viewport)
		viewport.queue_free()

extends CharacterBody2D

@export var resource:Resource
var mouseOver: bool
@onready var sprite = $Sprite2D
var animal_type: String
var product: String

func _ready() -> void:
	name = "Animal"
	resource = get_random_animal_data()
	sprite.texture = resource.texture
	animal_type = resource.animal_type
	product = resource.product

func get_random_animal_data() -> Resource:
	var dir_path = "res://Resources/animals/"
	var dir = DirAccess.open(dir_path)
	if not dir:
		push_error("Can't open directory: %s" % dir_path)
		return null
	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			files.append(dir_path + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	if files.is_empty():
		push_warning("No animal resources found in %s" % dir_path)
		return null

	var random_path = files[randi() % files.size()]
	return load(random_path)

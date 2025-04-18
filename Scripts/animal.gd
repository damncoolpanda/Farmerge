extends CharacterBody2D
@export var resource:Resource

var mouseOver: bool
enum States {IDLE, DRAGGING, SPAWNING}
enum EntityType {animal, product, tool}
var state: States = States.IDLE
var initial_position: Vector2
@onready var screen_size:Vector2 = get_viewport_rect().size
@onready var field:TileMapLayer = get_parent()
@onready var sprite = $Sprite2D
var animal_type: String
var product: String

func _ready() -> void:
	resource = get_random_animal_data()
	sprite.texture = resource.texture
	animal_type = resource.animal_type
	product = resource.product

func _input(event):
	move_animal(event)

func _on_mouse_entered() -> void:
	mouseOver = true

func _on_mouse_exited() -> void:
	mouseOver = false

func move_animal(event) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("LMB") && mouseOver:
			initial_position = position
			state = States.DRAGGING
			position = get_global_mouse_position()
		elif event.is_action_released("LMB") and state == States.DRAGGING:
			if field.grid_dict[field.local_to_map(snap_to_grid(get_global_mouse_position()))].occupied == false:
				position = snap_to_grid(snap_to_grid(get_global_mouse_position()))
			else:
				position = initial_position
			state = States.IDLE
			update_cell_occupation()
			
	elif event is InputEventMouseMotion:
		if state == States.DRAGGING:
			position = get_global_mouse_position()

func snap_to_grid(pos: Vector2i) -> Vector2i:
	pos = field.map_to_local(field.local_to_map(pos))
	pos[0] = clamp(pos[0], 32, screen_size[0] - 32)
	pos[1] = clamp(pos[1], 32, screen_size[1] - 32)
	return pos

func update_cell_occupation() -> void:
	# Clear initial cell
	var initial_cell = field.local_to_map(initial_position)
	var target_cell = field.local_to_map(position)
	field.grid_dict[initial_cell].occupied = false
	field.grid_dict[initial_cell].occupied_by = ""
	# Occupy new cell
	field.grid_dict[target_cell].occupied = true
	field.grid_dict[target_cell].occupied_by = animal_type

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

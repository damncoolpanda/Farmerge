extends CharacterBody2D

var mouseOver: bool
var dragging: bool = false
var initial_index: int
@onready var screen_size:Vector2 = get_viewport_rect().size
@onready var field:TileMapLayer = get_parent()

func _input(event):
	move_animal(event)

func _on_mouse_entered() -> void:
	mouseOver = true

func _on_mouse_exited() -> void:
	mouseOver = false

func move_animal(event) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("LMB") && mouseOver:
			initial_index = get_current_occupied_cell()
			dragging = true
			position = get_global_mouse_position()
		elif event.is_action_released("LMB") and dragging:
			dragging = false
			position = snap_to_grid(get_global_mouse_position())
			update_occupied_cell()
	elif event is InputEventMouseMotion:
		if dragging:
			position = get_global_mouse_position()

func snap_to_grid(pos: Vector2i) -> Vector2i:
	pos = field.map_to_local(field.local_to_map(pos))
	pos[0] = clamp(pos[0], 32, screen_size[0] - 32)
	pos[1] = clamp(pos[1], 32, screen_size[1] - 32)
	return pos

func get_current_occupied_cell():
	for index in field.get_used_cells().size():
		if field.local_to_map(position) == field.get_used_cells()[index]:
			return index
	assert(false,"'get_cells_occupation()' --> position cell not found")

func update_occupied_cell() -> void:
	for index in field.get_used_cells().size():
		if field.get_used_cells()[index] == field.local_to_map(position):
			field.cells_occupation[initial_index] = 0
			field.cells_occupation[index] = 1

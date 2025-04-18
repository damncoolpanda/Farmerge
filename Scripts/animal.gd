extends CharacterBody2D

var mouseOver: bool
enum States {IDLE, DRAGGING, SPAWNING}
var state: States = States.IDLE
var initial_position: Vector2
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
			initial_position = position
			state = States.DRAGGING
			position = get_global_mouse_position()
		elif event.is_action_released("LMB") and state == States.DRAGGING:
			state = States.IDLE
			position = snap_to_grid(get_global_mouse_position())
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
	field.grid_dict[field.local_to_map(initial_position)]["occupied"] = false
	field.grid_dict[field.local_to_map(initial_position)]["occupied_by"] = null
	# Occupy new cell
	field.grid_dict[field.local_to_map(position)]["occupied"] = true
	field.grid_dict[field.local_to_map(position)]["occupied_by"] = "animal"

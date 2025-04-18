extends Node2D
class_name Draggable

@onready var parent_node = get_parent()
@onready var field:TileMapLayer = parent_node.get_parent()
@onready var screen_size:Vector2 = get_viewport().size

@onready var initial_position: Vector2
enum States {IDLE, DRAGGING, SPAWNING}
var state: States = States.IDLE

func _input(event):
	move_animal(event)

func move_animal(event) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("LMB") && parent_node.mouseOver:
			initial_position = parent_node.position
			state = States.DRAGGING
			parent_node.position = get_global_mouse_position()
		elif event.is_action_released("LMB") and state == States.DRAGGING:
			if field.grid_dict[field.local_to_map(snap_to_grid(get_global_mouse_position()))].occupied == false:
				parent_node.position = snap_to_grid(snap_to_grid(get_global_mouse_position()))
			else:
				parent_node.position = initial_position
			state = States.IDLE
			update_cell_occupation()
			
	elif event is InputEventMouseMotion:
		if state == States.DRAGGING:
			parent_node.position = get_global_mouse_position()
			
func _on_animal_mouse_entered() -> void:
	parent_node.mouseOver = true

func _on_animal_mouse_exited() -> void:
	parent_node.mouseOver = false

func snap_to_grid(pos: Vector2i) -> Vector2i:
	pos = field.map_to_local(field.local_to_map(pos))
	pos[0] = clamp(pos[0], 32, screen_size[0] - 32)
	pos[1] = clamp(pos[1], 32, screen_size[1] - 32)
	return pos

func update_cell_occupation() -> void:
	# Clear initial cell
	var initial_cell = field.local_to_map(initial_position)
	var target_cell = field.local_to_map(parent_node.position)
	field.grid_dict[initial_cell].occupied = false
	field.grid_dict[initial_cell].occupied_by = ""
	# Occupy new cell
	field.grid_dict[target_cell].occupied = true
	field.grid_dict[target_cell].occupied_by = parent_node.animal_type

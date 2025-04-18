extends Node2D

@onready var screen_size = get_viewport_rect().size
var field:TileMapLayer = preload("res://Scenes/field.tscn").instantiate()

func _ready() -> void:
	randomize()
	start_print()
	add_child(field)

func start_print():
	print('Game Start')
	DisplayServer.window_set_current_screen(1)
	#print(DisplayServer.screen_get_position(1))
	#print('Current screen size: ', DisplayServer.window_get_size_with_decorations(0))
	#print('Current screen size: ', DisplayServer.window_get_size(0))
	#print('Viewport properties: ', get_viewport_rect())
	print('Viewport size: ', get_viewport_rect().size)

func _input(_event: InputEvent) -> void:
	#Prints Nodes Tree
	if Input.is_action_just_pressed("Print Tree"):
		print(get_tree_string_pretty())

	#Prints Grid Dictionary:
	if Input.is_action_just_pressed("Print Occupied Cells"):
		for cell in field.grid_dict:
			if field.grid_dict[cell].occupied == true:
				var str_format = "%s: occupied: %s, occupied_by: %s, locked: %s"
				var str_vars = [cell,field.grid_dict[cell].occupied,field.grid_dict[cell].occupied_by,field.grid_dict[cell].locked]
				var complete_str = str_format % str_vars
				print(complete_str)

	#Spawns a random animal:
	if Input.is_action_just_pressed("Spawn Animal"):
		if field.free_cells.size() > 0:
			field.add_animal(field.new_animal, field.random_cell())
		else:
			push_warning("No free cells available")

extends TileMapLayer

var grid_dict: Dictionary = {}
var grid_size: Array = [10,6]
var free_cells = []

@export var animals:Array[PackedScene] = []
var new_animal # a placeholder for 'animal' argument of 'add_animal()' function

func _ready() -> void:
	start_print()
	init_grid()
	calc_free_cells()
	#add_animal(new_animal, Vector2i(randi_range(0, grid_size[0]-1),randi_range(0, grid_size[1]-1))) #'animal' argument is not currently used 
	add_animal(new_animal, random_cell()) #'animal' argument is not currently used 

func _process(_delta: float) -> void:
	pass

func start_print() -> void:
	#print('TileMapLayer Array: ', get_used_cells())
	print('Grid columns: ', get_used_cells()[-1][0]+1)
	print('Grid rows: ', get_used_cells()[-1][1]+1)
	#print('Tile coords (by ID): ', self.map_to_local(self.get_used_cells()[1]))
	#print('Tile Vector2D (by ID): ', self.get_used_cells()[27])
	#print('Tile Vector2D (by coords): ', self.local_to_map(Vector2i(288,224)))

func init_grid() -> void:
	for x in range(grid_size[0]):
		for y in range(grid_size[1]):
			grid_dict[Vector2i(x,y)] = {
				"locked" = false,
				"occupied" = false,
				"occupied_by" = null
			}
	#print(grid_dict)


func add_animal(_animal, location) -> void: # 'animal' arg not used yet — just here for future plans
	# For now, picking a random animal happens here
	# Might move it somewhere else later
	var temp_animal = animals.pick_random()
	var current_animal = temp_animal.instantiate()
	add_child(current_animal)
	current_animal.position = map_to_local(location)
	grid_dict[local_to_map(current_animal.position)]["occupied"] = true
	grid_dict[local_to_map(current_animal.position)]["occupied_by"] = "animal"
	print("'New animal' tile-position: ", local_to_map(current_animal.position))
	calc_free_cells()

func _input(_event):
	#Prints Grid Dictionary:
	if Input.is_action_just_pressed("Print Occupied Cells"):
		for cell in grid_dict:
			if grid_dict[cell]["occupied"]:
				print(cell, ": ", grid_dict[cell])
				#print(cell,": ",grid_dict[cell]["occupied"])
				#print(cell,": ",grid_dict[cell]["occupied_by"])
	if Input.is_action_just_pressed("Spawn Animal"):
		if free_cells.size() > 0:
			add_animal(new_animal, random_cell())
		else:
			push_warning("No free cells available")
		
func random_cell() -> Vector2i:
	var random = Vector2i(randi_range(0, grid_size[0]-1),randi_range(0, grid_size[1]-1))
	if grid_dict[random]["occupied"] == false:
		return random
	return random_cell()
	
func calc_free_cells() -> int:
	free_cells = []
	for cell in grid_dict:
		if not grid_dict[cell]["occupied"]:
			free_cells.append(cell)
	return free_cells.size()

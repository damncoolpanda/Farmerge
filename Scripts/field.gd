extends TileMapLayer

var grid_dict: Dictionary = {}
var grid_size: Vector2i = Vector2i(10,6)
var free_cells = []

@export var animal:PackedScene
var new_animal # a placeholder for 'animal' argument of 'add_animal()' function

func _ready() -> void:
	start_print()
	init_grid()
	calc_free_cells()
	#add_animal(new_animal, Vector2i(randi_range(0, grid_size.x-1),randi_range(0, grid_size.y-1))) #'animal' argument is not currently used 
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
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid_dict[Vector2i(x,y)] = CellData.new()
	#print(grid_dict)


func add_animal(_animal, location) -> void: # 'animal' arg not used yet — just here for future plans
	# For now, picking a random animal happens here
	# Might move it somewhere else later
	var current_animal = animal.instantiate()
	add_child(current_animal)
	current_animal.position = map_to_local(location)
	grid_dict[local_to_map(current_animal.position)].occupied = true
	grid_dict[local_to_map(current_animal.position)].occupied_by = current_animal.animal_type
	print("'New animal' grid-position: ", local_to_map(current_animal.position))
	calc_free_cells()

func random_cell() -> Vector2i:
	var random = Vector2i(randi_range(0, grid_size.x-1),randi_range(0, grid_size.y-1))
	if grid_dict[random].occupied == false:
		return random
	return random_cell()
	
func calc_free_cells() -> int:
	free_cells = []
	for cell in grid_dict:
		if not grid_dict[cell].occupied:
			free_cells.append(cell)
	return free_cells.size()

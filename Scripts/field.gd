extends TileMapLayer

var animal_obj = preload("res://Scenes/animal.tscn")
var cell_amount = 59
var cells_occupation: Array = []
var new_animal

func _ready() -> void:
	prepare_occupation_array()
	start_print()
	new_animal = add_animal(animal_obj, randi_range(0,cell_amount))

func _process(delta: float) -> void:
	pass

func add_animal(animal, location):
	var new_animal = animal.instantiate()
	add_child(new_animal)
	new_animal.position = map_to_local(get_used_cells()[location])
	for index in get_used_cells().size():
		if get_used_cells()[index] == local_to_map(new_animal.position):
			cells_occupation[index] = 1
	#print("'New animal' position: ",new_animal.position)
	#print("'New animal' tile-position: ", local_to_map(new_animal.position))
	return new_animal

func start_print() -> void:
	print('TileMapLayer Array: ', get_used_cells())
	#print('Tile coords (by ID): ', self.map_to_local(self.get_used_cells()[1]))
	#print('Tile Vector2D (by ID): ', self.get_used_cells()[27])
	#print('Tile Vector2D (by coords): ', self.local_to_map(Vector2i(288,224)))
	
func _input(event):
	#Prints Cells Occupation Array:
	if Input.is_physical_key_pressed(KEY_C):
		print(cells_occupation)
		
func prepare_occupation_array() -> void:
	cells_occupation.resize(60)
	cells_occupation.fill(0)

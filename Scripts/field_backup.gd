extends TileMapLayer

var cell_amount: int = 59
var grid_dict: Dictionary = {}
var grid_size: Array = [10,6]

@export var animals:Array[PackedScene] = []
#var animal_scene = preload("res://Scenes/animal.tscn")
var animal_scene = animals.pick_random()
var new_animal

func _ready() -> void:
	start_print()
	init_grid_dict()
	new_animal = add_animal(animal_scene, randi_range(0,cell_amount))

func _process(_delta: float) -> void:
	pass

func add_animal(animal, location):
	print(animals)
	new_animal = animal.instantiate()
	add_child(new_animal)
	new_animal.position = map_to_local(get_used_cells()[location])
	grid_dict[str(local_to_map(new_animal.position))]["occupied"] = true
	grid_dict[str(local_to_map(new_animal.position))]["occupied_by"] = "animal"
	print("'New animal' tile-position: ", local_to_map(new_animal.position))
	return new_animal

func start_print() -> void:
	#print('TileMapLayer Array: ', get_used_cells())
	print('Grid columns: ', get_used_cells()[-1][0]+1)
	print('Grid rows: ', get_used_cells()[-1][1]+1)
	#print('Tile coords (by ID): ', self.map_to_local(self.get_used_cells()[1]))
	#print('Tile Vector2D (by ID): ', self.get_used_cells()[27])
	#print('Tile Vector2D (by coords): ', self.local_to_map(Vector2i(288,224)))
	
func _input(_event):
	#Prints Grid Dictionary:
	if Input.is_action_just_pressed("Print Occupied Cells"):
		for cell in grid_dict:
			if grid_dict[cell]["occupied"]:
				print(cell, ": ", grid_dict[cell])
				#print(cell,": ",grid_dict[cell]["occupied"])
				#print(cell,": ",grid_dict[cell]["occupied_by"])

func init_grid_dict() -> void:
	for x in range(grid_size[0]):
		for y in range(grid_size[1]):
			grid_dict[str(Vector2i(x,y))] = {
				"locked" = false,
				"occupied" = false,
				"occupied_by" = null
			}
	#print(grid_dict)

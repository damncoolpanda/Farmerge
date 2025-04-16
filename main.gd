extends Node2D

@onready var screen_size = get_viewport_rect().size
var field:TileMapLayer = preload("res://Scenes/field.tscn").instantiate()

func _ready() -> void:
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

	
func _input(event: InputEvent) -> void:
	#Prints Nodes Tree
	if Input.is_physical_key_pressed(KEY_T):
		print(get_tree_string_pretty())

extends Object
class_name CellData

@export var locked: bool = false
@export var occupied: bool = false
@export var occupied_by: String = ""

func clear():
	locked = false
	occupied = false
	occupied_by = ""

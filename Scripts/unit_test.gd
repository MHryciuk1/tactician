extends Node

@onready var hex_grid = $Hex_Grid
@onready var logic_manager = $Logic_Manager
@export var knight_scene : PackedScene
func _ready() -> void:
	var new_unit = knight_scene.instantiate()
	new_unit.init(logic_manager, hex_grid, Vector2i(0,0), "team1")
	add_child(new_unit)
	
	print(new_unit.stats)
	print(new_unit.check_attack(Vector2i(1,0)))
	print(new_unit.check_attack(Vector2i(1,2)))
	
	new_unit.on_attacked(null, 2)
	print(new_unit.stats)

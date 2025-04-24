extends Node2D
@onready var logic_manager = $Logic_Manager
@onready var ui = $UI
@onready var grid = $Hex_Grid
@onready var p1_units = $Units/P1_Units
@onready var p2_units =$Units/P2_Units
@export var archer : PackedScene
func _ready() -> void:
	ui.init(logic_manager)
	
	var test_unit = archer.instantiate()
	test_unit.init(logic_manager, grid, ui, Vector2i(-1,-1), "player1")
	p1_units.add_child(test_unit)
	var test_unit2 = archer.instantiate()
	test_unit2.init(logic_manager, grid, ui, Vector2i(0,-2), "player2")
	p2_units.add_child(test_unit2)
	pass
	
func _on_hex_grid_cell_left_clicked() -> void:
	pass # Replace with function body.


func _on_hex_grid_cell_right_clicked() -> void:
	pass # Replace with function body.

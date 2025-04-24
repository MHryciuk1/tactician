extends Node2D
@onready var logic_manager = $Logic_Manager
@onready var ui = $UI
@onready var grid = $Hex_Grid
@onready var p1_units = $Units/P1_Units
@onready var p2_units =$Units/P2_Units
@onready var turn_panel = $UI/TurnPanel
@export var knight: PackedScene
@export var scout: PackedScene #no scout scene currently; just using knight
@export var archer : PackedScene
func _ready() -> void:
	ui.init(logic_manager)
	turn_panel.hide()
	
	
	#var test_unit = archer.instantiate()
	#test_unit.init(logic_manager, grid, ui, Vector2i(-1,-1), "player1")
	#p1_units.add_child(test_unit)
	#var test_unit2 = archer.instantiate()
	#test_unit2.init(logic_manager, grid, ui, Vector2i(0,-2), "player2")
	#p2_units.add_child(test_unit2)
	
	
func _on_hex_grid_cell_left_clicked(curr_hex) -> void:
	print("left clicked")
	print(curr_hex)
	var new_unit = null
	if knight_selected:
		new_unit = knight.instantiate()
	if archer_selected:
		new_unit = archer.instantiate()
	if scout_selected:
		new_unit = scout.instantiate()
	if new_unit != null:
		if logic_manager.current_player == 1:	
			new_unit.init(logic_manager, grid, ui, curr_hex, "player1")
			p1_units.add_child(new_unit)
		else:
			new_unit.init(logic_manager, grid, ui, curr_hex, "player2")
			p2_units.add_child(new_unit)


func _on_hex_grid_cell_right_clicked() -> void:
	pass # Replace with function body.

var knight_selected = false
var scout_selected = false
var archer_selected = false
func _on_knight_pressed() -> void:
	print("knight pressed")
	knight_selected = true
	scout_selected = false
	archer_selected = false

func _on_scout_pressed() -> void:
	scout_selected = true
	knight_selected = false
	archer_selected = false
	
func _on_archer_pressed() -> void:
	archer_selected = true
	scout_selected = false
	knight_selected = false

func _on_end_turn_pressed() -> void:
	archer_selected = false
	scout_selected = false
	knight_selected = false
	if logic_manager.current_player == 1:
		logic_manager.current_player = 2
	else:
		var panel = $UI/Unit_Placement_Panel
		panel.hide()
		turn_panel.show()
		# end placement phase
	

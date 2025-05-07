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

@export var healthbar: PackedScene

func setup(server_data : Dictionary) -> void:
	print(server_data)
	grid.init(server_data.hex_layout)
	ui.init(logic_manager, grid)
	logic_manager.init(grid, ui, [p1_units,p2_units], server_data.player_name, server_data.turn_start)

func _ready() -> void:
	pass
	
	#var test_unit = archer.instantiate()
	#test_unit.init(logiac_manager, grid, ui, Vector2i(-1,-1), 1)
	#p1_units.add_child(test_unit)
	#var test_unit2 = archer.instantiate()
	#test_unit2.init(logic_manager, grid, ui, Vector2i(0,-2), 2)
	#p2_units.add_child(test_unit2)

	
	
var p1_cost = 5
var p2_cost = 5
func _on_hex_grid_cell_left_clicked(curr_hex) -> void:
	print("left clicked")
	print(curr_hex)
	var new_unit = null

	pass
func selection_handler(hex : Vector2i) -> void:
	var new_unit : Unit= null

	if knight_selected:
		new_unit = knight.instantiate()
	if archer_selected:
		new_unit = archer.instantiate()
	if scout_selected:
		new_unit = scout.instantiate()
	if new_unit != null:

		new_unit.init(logic_manager, grid, ui, hex, logic_manager.current_player)
		if logic_manager.current_player == 1:
			p1_units.add_child(new_unit)
		elif logic_manager.current_player == 2:
			p2_units.add_child(new_unit)
		archer_selected = false
		scout_selected = false
		knight_selected = false
func _on_hex_grid_cell_left_clicked(hex : Vector2i) -> void:
	if archer_selected or scout_selected or knight_selected:
		selection_handler(hex)
		return
	ui.show_hex_data(hex)
	if (grid.line_drawing_mode) and (not ui.selection_mode_on) and (not grid.hex_ocupied(hex)):
		logic_manager.move_to(ui.move_source,hex)

	print("left clicked")
	
			
	
	
	#var test_unit = archer.instantiate()
	#test_unit.init(logic_manager, grid, ui, Vector2i(-1,-1), "player1")
	#p1_units.add_child(test_unit)
	#var test_unit2 = archer.instantiate()
	#test_unit2.init(logic_manager, grid, ui, Vector2i(0,-2), "player2")
	#p2_units.add_child(test_unit2)
	
	




func _on_hex_grid_cell_right_clicked(hex : Vector2i) -> void:
	
	grid.disable_line_drawing_mode()
	pass # Replace with function body.

var knight_selected = false
var scout_selected = false
var archer_selected = false
func _on_knight_pressed() -> void:
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
	#if logic_manager.current_player == 2:
		#var panel = $UI/Unit_Placement_Panel
		#panel.hide()
		#turn_panel.show()
		#logic_manager.actions_enabled = true
		## end placement phase
	logic_manager.send_starting_units()

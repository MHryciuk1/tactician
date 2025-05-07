class_name  Logic_Manager
extends Node
var unit_containers : Array = []
var hex_grid : Hex_Grid = null
var units : Array = []
var ui : UIManager = null
var turn_number: int = 1
var current_player: int = 1
var p1vision: Array = []
var p2vision: Array = []
var actions_enabled : bool = false

func init(hex_grid_ref : Hex_Grid, ui_ref : UIManager, containers : Array) -> void:
	unit_containers = containers
	hex_grid = hex_grid_ref
	ui = ui_ref
	
func do_effect(source_unit: Node, effect_function:Callable, targets: Array) -> void:
	for target in targets:
		effect_function.call( target)
	$attacksound.play()
	# other stuff needs to happen here? like ui updates or something

func move_to(unit: Unit, target_cord: Vector2i) -> void:
	var path = hex_grid.get_hexes_along_path_to(unit.current_cord, target_cord)
	var actual_target  : Vector2i= path.pop_front()
	print(path)
	print(unit.stats.move_range)
	for i in path:
		var hex_data : Array = hex_grid.get_cell_data(i)
		if(unit.stats.move_range - hex_data[hex_grid.CELL_MOVE_COST]) >= 0:
			unit.stats.move_range -= hex_data[hex_grid.CELL_MOVE_COST]
			actual_target = i
		else:
			break
	#var movable = can_move_to(unit, target_cord)
	if unit.current_cord == actual_target:
		print("No movement possible for ", unit.unit_type)
		return
	var cur_vision = hex_grid.get_valid_spaces(unit.current_cord, unit.get_stats().vision_range)
	hex_grid.obscure_hexes(cur_vision) # this doesn't fully work but can fix later
	var target_vision = hex_grid.get_valid_spaces(actual_target, unit.get_stats().vision_range)
	hex_grid.reveal_hexes(target_vision)
	hex_grid.set_hex_empty(unit.current_cord)
	hex_grid.set_node_location(unit, actual_target)
	
	
	unit.current_cord = actual_target
	hex_grid.draw_line_on_grid(actual_target, hex_grid.curr_hex)
	#need to update vision arrays and update fog based on where unit is moved to
	print(unit.unit_type, "moved to: ", actual_target)

	#hex_grid.set_node_location(unit, target_cord)
	#unit.current_cord = target_cord
	##update vision
	
	#
	#print(unit.unit_type, "moved to: ", target_cord)




func can_move_to(unit: Unit, target_cord: Vector2i) -> bool:
	var path = hex_grid.get_hexes_along_path_to(unit.current_cord, target_cord)
	
	return (len(path) <= unit.get_stats()['move_range'])



func turn_end() -> void:
	current_player = 3 - current_player
	turn_number += 1
	
	for i in unit_containers[current_player-1].get_children():
		i.turn_end()
	
	hex_grid.obscure_hexes(p1vision)
	hex_grid.reveal_hexes(p2vision)
	ui._update_turn_display(turn_number,current_player)
	ui.disable_movement()
	ui.cancel_selection_mode()
	#need to turn all hexes except those in current player's vision to fog
	#also need to reset all unit's movement numbers



func on_unit_death(unit: Node) -> void:
	if hex_grid:
		hex_grid.clear_hex(unit.current_cord)
	
	if unit in units:
		units.erase(unit)
	unit.queue_free()
	$deathsound.play()
	print("Unit ", unit.unit_type, " has been defeated.")
	if units.is_empty():
		print("game over!")
	#need some way to check if game is over

func get_visible_coords() -> Array:
	var visible_coords := []
	for unit in units:
		var center = unit.current_cord
		var vision = unit.get_stats()["vision_range"]
		var spaces = hex_grid.get_valid_spaces(center, vision)
		for coord in spaces:
			if not visible_coords.has(coord):
				visible_coords.append(coord)
	return visible_coords

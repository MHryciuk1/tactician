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
<<<<<<< Updated upstream

func init(hex_grid_ref : Hex_Grid, ui_ref : UIManager, containers : Array) -> void:
=======
var unique_id_to_unit : Dictionary[int,Unit] = {}
var unit_scenes = [
	load("res://Nodes/Units/Knight_Unit.tscn"),
	load("res://Nodes/Units/Scout_Unit.tscn"),
	load("res://Nodes/Units/archer_unit.tscn")
]
func send_starting_units():
	
	var payload = []
	for i in unit_containers[current_player-1].get_children():
		payload.append([i.unit_id, i.current_cord])
	print(str(player_name, " ", unit_containers[current_player-1].get_children()))
	server_send_starting_units.rpc(payload)
func place_units(units) -> void:
	for i in units.data:
		assert(i.id !=0)
		var new_unit = unit_scenes[i.id-1].instantiate()
		new_unit.init(self, hex_grid, ui, i.pos, i.team)
		new_unit.stats = i.stats
		new_unit.moves = i.moves
		new_unit.unique_id = i.unique_id
		unique_id_to_unit[new_unit.unique_id] = new_unit
		unit_containers[i.team-1].add_child(new_unit)
		
@rpc("authority","call_remote","unreliable_ordered")
func set_up_response(res) -> void:
	print(player_name," setup")
	if res.status == 1:
		print("Unit Error")
	elif res.status == 0:
		print("Units Good")
		print(res.data)
		ui.close_placement_pannel()
		current_player = 2
		var units : Array = unit_containers[0].get_children()
		for i in range(res.data.size()):
			units[i].unique_id = res.data[i].unique_id
			unique_id_to_unit[units[i].unique_id] = units[i]
	else:
		print("Enemy Placement")
		print(res)
		place_units(res)
		
		if(res.begin_placement):
			current_player = 1
			ui.open_placement_pannel()
	print(unique_id_to_unit)
			
@rpc("authority","call_remote","unreliable_ordered")
func turn_start() -> void:
	print(str("turn start ", player_name))
	current_player = 1
	actions_enabled = true
	ui.open_turn_pannel()
	hex_grid.update_vision(get_visible_coords())
	#print(current_player)
	
	
@rpc()#this is not going to be called localy, see the server function with the same name to see what it does
func server_send_starting_units() -> void:
	pass
func init(hex_grid_ref : Hex_Grid, ui_ref : UIManager, containers : Array, name : String, turn_start : int) -> void:
	print(get_path())
	player_name = name
>>>>>>> Stashed changes
	unit_containers = containers
	hex_grid = hex_grid_ref
	ui = ui_ref
	
func do_effect(source_unit: Node, effect_function:Callable, targets: Array) -> void:
	for target in targets:
		effect_function.call( target)
	$attacksound.play()
	# other stuff needs to happen here? like ui updates or something
<<<<<<< Updated upstream

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
=======
@rpc()
func move_request(source : int, target : Vector2i) -> void:
	pass
func update_unit(update : Dictionary) -> void :
	var unit : Unit = unique_id_to_unit.get(update.unique_id)
	if (!unit):
		print("unit does not exist")
		return
		unit.stats = update.stats
		unit.current_cord = update.pos
	
	unit.moves = update.moves
	if(update.pos != unit.current_cord):
		hex_grid.get_cell_data(unit.current_cord)[hex_grid.CELL_OCCUPANT] = null
		hex_grid.set_node_location(unit, update.pos)
		hex_grid.update_vision(get_visible_coords())
@rpc("authority","call_remote","unreliable_ordered")
func unit_update(update : Array[Dictionary]) -> void:
	print(str("unit_update ", player_name, update))
	for i in update:
		update_unit(i)
	
func move_to(unit: Unit, target_cord: Vector2i) -> void:
	print(unique_id_to_unit)
	move_request.rpc( unit.unique_id,target_cord)
	hex_grid.update_vision(get_visible_coords())
	#var path = hex_grid.get_hexes_along_path_to(unit.current_cord, target_cord)
	#var actual_target  : Vector2i= path.pop_front()
	#print(path)
	#print(unit.stats.move_range)
	#for i in path:
		#var hex_data : Array = hex_grid.get_cell_data(i)
		#if(unit.stats.move_range - hex_data[hex_grid.CELL_MOVE_COST]) >= 0:
			#unit.stats.move_range -= hex_data[hex_grid.CELL_MOVE_COST]
			#actual_target = i
		#else:
			#break
	##var movable = can_move_to(unit, target_cord)
	#if unit.current_cord == actual_target:
		#print("No movement possible for ", unit.unit_type)
		#return
	#var cur_vision = hex_grid.get_valid_spaces(unit.current_cord, unit.get_stats().vision_range)
	#hex_grid.obscure_hexes(cur_vision) # this doesn't fully work but can fix later
	#var target_vision = hex_grid.get_valid_spaces(actual_target, unit.get_stats().vision_range)
	#hex_grid.reveal_hexes(target_vision)
	#hex_grid.set_hex_empty(unit.current_cord)
	#hex_grid.set_node_location(unit, actual_target)
	#
	#
	#unit.current_cord = actual_target
	#hex_grid.draw_line_on_grid(actual_target, hex_grid.curr_hex)
	##need to update vision arrays and update fog based on where unit is moved to
	#print(unit.unit_type, "moved to: ", actual_target)
>>>>>>> Stashed changes

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
	for unit in unit_containers[0].get_children():
		var center = unit.current_cord
		var vision = unit.get_stats()["vision_range"]
		var spaces = hex_grid.get_valid_spaces(center, vision)
		for coord in spaces:
			if not visible_coords.has(coord):
				visible_coords.append(coord)
	return visible_coords

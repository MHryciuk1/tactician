class_name  Logic_Manager
extends Node

var unit_containers : Array = []
var hex_grid : Hex_Grid = null
var units : Array = []
var ui : UIManager = null
var turn_number: int = 1
var current_player: int = 1
var player_name =  "Player 1"
var p1vision: Array = []
var p2vision: Array = []
var actions_enabled : bool = false
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
	ui.update_turn_pop_up_display(turn_number)
	ui.show_turn_pop_up()
	await get_tree().create_timer(1).timeout
	ui.hide_turn_pop_up()
	current_player = 1
	actions_enabled = true
	ui.open_turn_pannel()

	#print(current_player)
	
	
@rpc()#this is not going to be called localy, see the server function with the same name to see what it does
func server_send_starting_units() -> void:
	pass
func init(hex_grid_ref : Hex_Grid, ui_ref : UIManager, containers : Array, name : String, turn_start : int) -> void:
	print(get_path())
	player_name = name
	unit_containers = containers
	hex_grid = hex_grid_ref
	ui = ui_ref
	current_player = turn_start + 1
	if(current_player == 1):
		ui.open_placement_pannel()
@rpc()
func effect_request(source_unique_id : int, target_unique_id : Array[int], move_name : String) -> void:
	pass
func do_effect(source_unit: Unit, effect_name : String, targets: Array) -> void:
	var target_ids : Array[int] = []
	for i in targets:
		target_ids.append(i.unique_id)
	effect_request.rpc(source_unit.unique_id, target_ids, effect_name )
	$attacksound.play()
	# other stuff needs to happen here? like ui updates or something
@rpc("authority", "call_remote", "unreliable_ordered")
func game_over(i_won : bool) -> void:
	if i_won:
		print("i win")
	else:
		print("i lost")
@rpc()
func move_request(source : int, target : Vector2i) -> void:
	pass
func update_unit(update : Dictionary) -> void :
	var unit : Unit = unique_id_to_unit.get(update.unique_id)
	if (!unit):
		print("unit does not exist")
		return
	unit.stats = update.stats
	
	unit._update_bar()
	unit.moves = update.moves
	if(update.pos != unit.current_cord):
		unit.current_cord = update.pos
		if ui.move_source == unit:
			var valid_moves = hex_grid.get_valid_spaces(unit.current_cord, unit.get_stats().attack_range,false)
			hex_grid.highlight_hexes(valid_moves, Color.BLUE)
		hex_grid.get_cell_data(unit.current_cord)[hex_grid.CELL_OCCUPANT] = null
		hex_grid.set_node_location(unit, update.pos)
	if(!update.alive):
		unique_id_to_unit.erase(update.unique_id)
		hex_grid.clear_hex(unit.current_cord)
		
@rpc("authority","call_remote","unreliable_ordered")
func unit_update(update : Array[Dictionary]) -> void:
	print(str("unit_update ", player_name, update))
	for i in update:
		update_unit(i)
	
func move_to(unit: Unit, target_cord: Vector2i) -> void:
	print(unique_id_to_unit)
	move_request.rpc( unit.unique_id,target_cord)
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

	#hex_grid.set_node_location(unit, target_cord)
	#unit.current_cord = target_cord
	##update vision
	
	#
	#print(unit.unit_type, "moved to: ", target_cord)




func can_move_to(unit: Unit, target_cord: Vector2i) -> bool:
	var path = hex_grid.get_hexes_along_path_to(unit.current_cord, target_cord)
	
	return (len(path) <= unit.get_stats()['move_range'])

@rpc()
func server_turn_end() -> void:
	pass
func turn_end() -> void:
	if(current_player == 2):
		print("not your turn")
		return
	current_player = 2
	turn_number += 1
	ui._update_turn_display(turn_number,current_player)
	ui.disable_movement()
	ui.cancel_selection_mode()
	server_turn_end.rpc()
	
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

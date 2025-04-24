extends Node

var hex_grid : Node = null
var units : Array = []
var ui : UIManager = null
var turn_number: int = 1
var current_player: int = 1
var p1vision: Array = []
var p2vision: Array = []


func do_effect(source_unit: Node, effect_function:Callable, targets: Array) -> void:
	for target in targets:
		effect_function.call(source_unit, target)
	# other stuff needs to happen here? like ui updates or something


func move_to(unit: Node, target_cord: Vector2) -> void:
	var movable = can_move_to(unit, target_cord)
	if !movable:
		print("No movement possible for ", unit.unit_type)
		return
	hex_grid.set_node_location(unit, target_cord)
	unit.current_cord = target_cord
	#need to update vision arrays and update fog based on where unit is moved to
	print(unit.unit_type, "moved to: ", target_cord)



func can_move_to(unit: Node, target_cord: Vector2) -> bool:
	var path = hex_grid.get_hexes_along_path_to(unit, target_cord)
	return (len(path) <= unit.get_stats()['move_range'])



func turn_end() -> void:
	current_player = 3 - current_player
	turn_number += 1
	#need to turn all hexes except those in current player's vision to fog
	#also need to reset all unit's movement numbers



func on_unit_death(unit: Node) -> void:
	if hex_grid:
		hex_grid.clear_hex(unit.current_cord)
	ui.remove_unit_icon(unit)
	if unit in units:
		units.erase(unit)
	unit.queue_free()
	print("Unit ", unit.unit_type, " has been defeated.")
	if units.is_empty():
		print("game over!")
	#need some way to check if game is over

extends Node

var hex_grid : Node = null
var units : Array = []

	


func do_effect(source_unit, effect_function:Callable, targets: Array) -> void:
	for target in targets:
		effect_function.call(source_unit, target)
	# other stuff needs to happen here? like ui updates or something


#tentative other version assuming only attacks possible for early testing
#func do_effect(source_unit, target) -> void:
	#var atk = source_unit.get_stats()['atk'] # assuming get_stats is a dictionary with each value
	#target.on_attacked(source_unit, atk)   #id assume ui effects are handled by the unit during this
	#if target.get_stats()['hp'] == 0:
		#on_unit_death(target)



func move_to(unit, target_cord: Vector2) -> void:
	var movable = can_move_to(unit, target_cord)
	if !movable:
		print("No movement possible for ", unit.name)
		return
	hex_grid.set_node_location(unit, target_cord)
	unit.position = target_cord
	print(unit.name, "moved to: ", target_cord)


# need to implement, not really sure how this calculation works with hexes
func can_move_to(unit, target_cord: Vector2) -> bool:
	return true



func turn_end() -> void:
	#need to decide what happens here
	print("Turn ended.")



func on_unit_death(unit) -> void:
	if hex_grid:
		hex_grid.clear_hex(unit.position)
	
	if unit in units:
		units.erase(unit)
	# don't know what this does but apparently it's supposed to be there
	unit.queue_free()
	print("Unit ", unit.type, " has been defeated.")
	if units.is_empty():
		print("game over!")
	#need some way to check if game is over

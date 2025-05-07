class_name Unit
extends Node2D


signal unit_selected(unit)
signal unit_moved(unit, to_coord)
signal unit_died(unit)
var unique_id :int = -1
var unit_id : int = 0
@export var team: int = 1
@export var unit_type: String = "soldier"
var stats : Dictionary = {
	"cost": 1,
	"hp": 10,
	"move_range" : 2,
	"max_move_range": 2,
	"attack_range": 1,
	"damage": 5,
	"vision_range": 2,
	"team": team
}
var logic_manager: Node = null
var hex_grid: Node = null
var ui  = null

func turn_end() -> void:
	stats.move_range = stats.max_move_range
	for i in moves.keys():
		var move = moves.get(i)
		move.uses_left = move.max_uses_per_turn
var moves = {
	"attack1" : Callable(attack_effect)
}

var current_cord: Vector2i
var alive: bool = true

func init(logic_ref: Node, grid_ref: Node, ui_ref : Node, start_cord: Vector2i, team_num : int) -> void:
	logic_manager = logic_ref
	ui = ui_ref
	hex_grid = grid_ref
	current_cord = start_cord
	team = team_num
	hex_grid.set_node_location(self, start_cord)

func get_stats() -> Dictionary:
	return stats

func check_attack(cord: Vector2i) -> bool:

	return current_cord.distance_to(cord) <= get_stats().attack_range #TODO distance_to will not return the number of hexes to the cord


func attack_effect(target: Unit) -> void:
	pass


func on_attacked(attacker: Node, dmg: int) -> void:
	stats.hp -= dmg
	if stats.hp <= 0 and alive:
		print("im dead")
		alive = false
		logic_manager.on_unit_death(self)
		emit_signal("unit_died", self)

func on_click():
	print(logic_manager.player_name)
	print(stats)
	var valid_moves = hex_grid.get_valid_spaces(current_cord, get_stats().attack_range,false)
	hex_grid.highlight_hexes(valid_moves, Color.BLUE)
	ui.send_data("test_ui_id", stats, moves, self)
	#send_data(ui_id: String, stats: Dictionary, moves: Array)
	

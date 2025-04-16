extends Node2D

signal unit_selected(unit)
signal unit_moved(unit, to_coord)
signal unit_died(unit)

@export var team: String = "player"
@export var unit_type: String = "soldier"

var logic_manager: Node = null
var hex_grid: Node = null

var stats = {
	"cost": 1,
	"hp": 10,
	"move_range": 2,
	"attack_range": 1,
	"damage": 5,
	"team": team
}

var current_cord: Vector2i
var alive: bool = true

func init(logic_ref: Node, grid_ref: Node, start_cord: Vector2i) -> void:
	logic_manager = logic_ref
	hex_grid = grid_ref
	current_cord = start_cord
	hex_grid.set_node_location(self, start_cord)

func get_stats() -> Dictionary:
	return stats

func check_attack(cord: Vector2i) -> bool:
	return current_cord.distance_to(cord) <= stats.attack_range

func attack_effect(target: Node) -> void:
	pass

func on_attacked(attacker: Node, dmg: int) -> void:
	stats.hp -= dmg
	if stats.hp <= 0 and alive:
		alive = false
		logic_manager.on_unit_death(self)
		emit_signal("unit_died", self)

class_name Knight
extends Unit

func get_stats() -> Dictionary:
	return {
	"cost": 1,
	"hp": 10,
	"move_range": 2,
	"attack_range": 1,
	"damage": 5,
	"team": team
	}

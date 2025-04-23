class_name Archer
extends Unit
func _ready() -> void:
	stats = {
			"cost": 1,
			"hp": 10,
			"move_range": 1,
			"attack_range": 3,
			"damage": 5,
			"team": team
		}
func attack_effect(target: Unit) -> void:
	target.on_attacked(target, stats.damage)
	pass


func _on_hitbox_sprite_left_clicked() -> void:
	pass # Replace with function body.
func _on_hitbox_sprite_right_clicked() -> void:
	pass # Replace with function body.

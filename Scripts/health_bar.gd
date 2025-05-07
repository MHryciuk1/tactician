extends Node2D

var max_health := 10
var current_health := 10

func set_health(value: int):
	current_health = clamp(value, 0, max_health)
	_update_bar()

func set_max_health(value: int):
	max_health = value
	_update_bar()

func _update_bar():
	var ratio = float(current_health) / max_health
	$Bar.scale.x = ratio

func _process(delta: float) -> void:
	self.position = Vector2(-60, -60)

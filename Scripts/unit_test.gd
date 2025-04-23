extends Node

@onready var hex_grid = $Hex_Grid
@export var knight_scene : PackedScene
func _ready() -> void:
	var new_unit = knight_scene.instantiate()
	hex_grid.set_node_location(new_unit, Vector2i(0,0))
	add_child(new_unit)

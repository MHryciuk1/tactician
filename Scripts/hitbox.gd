extends Node2D
signal sprite_left_clicked
signal sprite_right_clicked
var mouse_in: bool =  false
func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton) and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			sprite_left_clicked.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			sprite_right_clicked.emit()

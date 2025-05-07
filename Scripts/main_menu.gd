extends Control
@onready var instructions = $Instructions

func _on_start_button_pressed() -> void:
	pass


func _on_instructions_button_pressed() -> void:
	instructions.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	instructions.hide()

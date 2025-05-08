extends Control
@onready var instructions = $Instructions
@onready var options = $VBoxContainer

func _on_start_button_pressed() -> void:
	self.hide()
	var client = get_parent()
	var connection_menu = client.get_node("Connection_Menu")
	connection_menu.show()


func _on_instructions_button_pressed() -> void:
	instructions.show()
	options.hide()
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	instructions.hide()
	options.show()

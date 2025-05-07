extends Node
const  SERVER_PORT = 2000
const DEFAULT_SERVER_IP = "127.0.0.1"
@onready var addr_text_box : LineEdit = $Connection_Menu/VBoxContainer/Address
@export var level_scene : PackedScene
func connect_to_server(addr : String):
	var server_peer = ENetMultiplayerPeer.new()
	var error = server_peer.create_client(addr,SERVER_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = server_peer
func _ready() -> void:
	pass


func _on_button_pressed() -> void:
	var error = connect_to_server(addr_text_box.text)
	if error:
		print(error)
	pass # Replace with function body.
@rpc("authority", "call_remote", "unreliable_ordered")
func setup(data):
	print(data)
	$Connection_Menu.hide()
	var level = level_scene.instantiate()
	add_child(level)
	level.setup(data)

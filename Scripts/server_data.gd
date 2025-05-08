extends Node
class_name Server_Data
var hex_layout : Array
var start_hex : Vector2i
func init(raw_data : Array):
	hex_layout = raw_data[0]
	start_hex = raw_data[1]

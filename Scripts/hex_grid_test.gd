extends Node2D
@onready var hex_grid = $Hex_Grid


func _on_highlight_toggled(toggled_on: bool) -> void:
	var x =$Moveable_Camera/Highlight_Container/X.value
	var y = $Moveable_Camera/Highlight_Container/Y.value
	var r = $Moveable_Camera/Highlight_Container/R.value
	var color : Color =  $Moveable_Camera/Highlight_Container/Color_Picker_Button.color
	var hexes : Array = hex_grid.get_valid_spaces(Vector2i(x,y),r,false)
	if(toggled_on):
		hex_grid.highlight_hexes(hexes,  color)
	else:
		hex_grid.highlight_hexes(hexes,  Color.WHITE)
		

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
		


func _on_highlight_path_toggled(toggled_on: bool) -> void:
	var x1 = $Moveable_Camera/Path_Container/Cord_1/X.value
	var y1 = $Moveable_Camera/Path_Container/Cord_1/Y.value
	var x2 = $Moveable_Camera/Path_Container/Cord_2/X.value
	var y2 = $Moveable_Camera/Path_Container/Cord_2/Y.value	
	var hexes :Array =  hex_grid.get_hexes_along_path_to(Vector2i(x1,y1),Vector2i(x2,y2), false)
	if not hexes.is_empty():
		if(toggled_on):
			hex_grid.highlight_hexes(hexes,  Color.YELLOW)
		else:
			hex_grid.highlight_hexes(hexes,  Color.WHITE)

class_name Hex_Grid
extends TileMapLayer
const tile_size := 128
var curr_hex := Vector2i(-1,-1)
var curr_hex_set :bool = false
signal cell_left_clicked
signal cell_right_clicked
#could save on some space if i just use a hashmap but this should be slightly faster to access
enum  {
	CELL_LOCATION = 0,
	CELL_MOVE_COST = 1,
	CELL_OCCUPANT = 2,
	CELL_ID = 3
}
var pathfinding_graph = AStar2D.new()
var cell_data : Dictionary = {}
@export var hover_highlight_color : Color = Color.RED
@onready var highlight_layer : TileMapLayer = %Highlight_Layer
@onready var mouse_highlight_layer : TileMapLayer = %Mouse_Highlight_Layer
@onready var fog_layer : TileMapLayer = %Fog_Layer
@onready var line : Line2D = %Line
var line_drawing_mode : bool = false
var line_source : Unit
#kept as a sepreate function to make switching the representation of cell_data easier
func enable_line_drawing_mode(source : Unit) -> void:
	line_source = source
	line_drawing_mode = true 
func disable_line_drawing_mode() -> void:
	line_drawing_mode = false
	line.hide() 
func insert_to_cell_data(data, cord) ->void:
	
	cell_data[cord] = data
	#cell_data[cord.x][cord.y] = data
	#print(cell_data[cord.x][cord.y])
	#pass

func get_cell_data(cord : Vector2i):
	return cell_data.get(cord)
func _ready() -> void:
	var cells = get_used_cells()
	var to_connect : Array = []
	for i in cells:
		var id = pathfinding_graph.get_available_point_id()
		to_connect.append(id)
		pathfinding_graph.add_point(id,i,1)
		insert_to_cell_data([i,1,null, id], i)
		
		var text = Label.new()
		text.text=str("o: ",i,"\na: ", oddr_to_axial(i))
		text.add_theme_color_override("font_color", Color(0, 0, 0))
		text.position = map_to_local(i)
		add_child(text)
	for i in range(to_connect.size()):
		var adj := get_surrounding_cells(cells[i])
		for j in adj:
			var data = get_cell_data(j)
			if data:
				pathfinding_graph.connect_points(to_connect[i],data[CELL_ID])
	#print(cell_data)
	#print(get_valid_spaces(Vector2i(1,1),1))
	
func axial_to_oddr(axial_cord : Vector2i) -> Vector2i:
	var col = axial_cord.x + (axial_cord.y - (axial_cord.y&1)) / 2
	var row = axial_cord.y
	return Vector2i(col, row)
func oddr_to_axial(oddr_cord : Vector2i) -> Vector2i:
	var q = oddr_cord.x - (oddr_cord.y - (oddr_cord.y&1)) / 2
	var r = oddr_cord.y
	return Vector2i(q, r)
##for testing
#func mark_all_corners(center : Vector2, size : float) -> void:
	#for i in range(6):
		#var mark = Sprite2D.new()
		#mark.texture = load("res://icon.svg")
		#mark.scale = Vector2(.2,.2)
		#add_child(mark)
		##mark.position = get_corner(center, size, i+1, [])
		#print(mark.position)
##based on the function found in https://www.redblobgames.com/grids/hexagons/
#func get_corner(center: Vector2, size: float, i: float) -> Vector2:
	#var angle_deg = 60 * i - 30
	#var angle_rad = PI / 180 * angle_deg
	#return Vector2(center.x + size *cos(angle_rad),center.y + size * sin(angle_rad))
func draw_line_on_grid(source : Vector2i, dest : Vector2i) -> void:
	#print(get_hexes_along_path_to(source, dest, false))
	#print(str("s: ", source, "d ", dest))
	line.points = get_hexes_along_path_to(source, dest, false).map(Callable(map_to_local))
	
	line.show()
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_position := get_local_mouse_position()
		var map_cord := local_to_map(mouse_position)
		var should_draw_line : bool = false
		if not map_cord in get_used_cells():
			curr_hex_set = false
			mouse_highlight_layer.erase_cell(curr_hex)
			return
			
		if curr_hex_set and (map_cord !=curr_hex):
			mouse_highlight_layer.erase_cell(curr_hex)
			if line_drawing_mode:
				should_draw_line = true
			
		mouse_highlight_layer.set_cell(map_cord,0, Vector2i(0,0),0)
		curr_hex = map_cord
		curr_hex_set = true
		if should_draw_line:
			draw_line_on_grid(line_source.current_cord,curr_hex)
	if (event is InputEventMouseButton) and curr_hex_set and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			cell_left_clicked.emit(curr_hex)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			
			cell_right_clicked.emit(curr_hex)
		#if event is InputEventMouseButton:
func hex_ocupied(hex : Vector2i) -> bool:
	if get_cell_data(hex)[CELL_OCCUPANT]:
		return true
	return false
func get_valid_spaces(cord : Vector2i, radius : int, with_data : bool = false) -> Array:
	var axal_cord :Vector2i= oddr_to_axial(cord)
	var N = abs(radius)
	var out : Array = []
	for q in range((-1*N), N+1):
		#print(q)
		for r in range(max(-1*N,(-1*q)-N), min(N,(-1*q)+N)+1):
			var new_cor = axial_to_oddr(axal_cord+Vector2i(q,r))
			var data = get_cell_data(new_cor)
			if data:
				if with_data:
					out.append(data)
				else:
					print(data[0])
					out.append(data[0])
	return out

func get_hexes_along_path_to(cord_a : Vector2i, cord_b : Vector2i, data : bool = false, partial_path : bool = false) -> Array:
	var data_a = get_cell_data(cord_a)
	var data_b = get_cell_data(cord_b)
	if (not data_a) or (not data_b):
		print("error in hex_grid.gd/get_hexes_along_path_to: one of the cells don't exist")
		print(str("cord_a: ", cord_a))
		print(str("cord_b: ", cord_b))
		return []
	var raw_path : PackedVector2Array = pathfinding_graph.get_point_path(data_a[CELL_ID], data_b[CELL_ID], partial_path)
	if not data:
		return raw_path
	var out : Array = []
	for i in raw_path:
		out.append(get_cell_data(i))
	return out
func get_all_posible_movement_locations(cord :Vector2i,distance : int) -> Array:
	
	return []
func highlight_hexes(hexes : Array, color : Color) -> void:
	highlight_layer.clear()
	var erase : = true
	if color != Color.WHITE:
		erase = false
		color.a = .2
	for i in hexes:
		if erase:
			highlight_layer.erase_cell(i)
		else:
			highlight_layer.set_cell(i,0, Vector2i(0,0),0)
	if not erase:
		var data : TileData= highlight_layer.get_cell_tile_data(hexes[0])
		data.modulate = color
func obscure_hexes(hexes : Array) -> void:
	for i in hexes:
		fog_layer.set_cell(i,0, Vector2i(0,0),0)
func reveal_hexes(hexes : Array) -> void:
	for i in hexes:
		fog_layer.erase_cell(i)
func set_node_location(node : Node2D, cord : Vector2i) -> void :
	var data = get_cell_data(cord)
	if not data:
		print("Hex_Grig/set_node_location cell does not exist")
		return
	node.global_position = to_global(map_to_local(cord))
	data[CELL_OCCUPANT] = node
func set_hex_empty(hex : Vector2i) -> void:
	get_cell_data(hex)[CELL_OCCUPANT] =  null
func clear_hex(cord : Vector2i) -> void:
	var data = get_cell_data(cord)
	if not data:
		print("clear_hex/set_node_location cell does not exist")
		return
	if data[CELL_OCCUPANT]:
		data[CELL_OCCUPANT].queue_free()
		

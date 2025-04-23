extends CanvasLayer
class_name UIManager


#const UnitIconScene = preload("res://nodes/UI/unit.tscn")
#
#
#func add_unit_icon(cord: Vector2i, hex_grid: Node) -> void:
	#var icon = UnitIconScene.instance()
	#icon.position = hex_grid.to_global( hex_grid.map_to_local(cord) )
	#add_child(icon)
#
#func remove_unit_icon(unit: Node2D) -> void:
	#unit.queue_free()

func send_data(ui_id: String, stats: Dictionary, moves: Array) -> void:
	var panel: Control
	
	var lbl = Label.new()
	lbl.autowrap = true
	var text := ""
	for stat_name in stats.keys():
		text += "%s: %s\n" % [ stat_name.capitalize(), stats[stat_name]]
	lbl.text = text
	
	var move_list = panel.get_node("MoveOptions") as VBoxContainer
	move_list.clear()
	
	move_list.add_child(lbl)
	
	for move in moves:
		var b = Button.new()
		b.text = str(move)
		b.pressed.connect(do_move, move)
		move_list.add_child(b)

func do_move(move: String) -> void:
	var panel: Control
	var move_list = panel.get_node("MoveOptions") as VBoxContainer
	move_list.clear()
	

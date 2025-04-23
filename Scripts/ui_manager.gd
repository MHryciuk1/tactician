extends CanvasLayer
class_name UIManager

@onready var move_list: VBoxContainer = $MoveOptions

func send_data(ui_id: String, stats: Dictionary, moves: Array) -> void:
	
	var lbl = Label.new()
	lbl.autowrap = true
	var text := ""
	for stat_name in stats.keys():
		text += "%s: %s\n" % [ stat_name.capitalize(), stats[stat_name]]
	lbl.text = text
	
	for child in move_list.get_children():
		child.queue_free()
	
	move_list.add_child(lbl)
	
	for move in moves:
		var b = Button.new()
		b.text = str(move)
		b.pressed.connect(Callable(self, "do_move"), [move])
		move_list.add_child(b)

func do_move(move: String) -> void:
	for child in move_list.get_children():
		child.queue_free()
	

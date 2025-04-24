extends CanvasLayer
class_name UIManager

@onready var move_list: VBoxContainer = $MoveOptions
@onready var turn_label      = $TurnPanel/TurnLabel    as Label
@onready var player_label    = $TurnPanel/PlayerLabel  as Label
@onready var end_turn_button = $TurnPanel/EndTurnButton as Button
var lm: Node

func _ready() -> void:
	end_turn_button.pressed.connect(Callable(self, "_on_end_turn_pressed"))
	_update_turn_display(lm.turn_number, lm.current_player)
	
func _on_end_turn_pressed() -> void:
	lm.turn_end()
	_update_turn_display(lm.turn_number, lm.current_player)
	
func _update_turn_display(turn_number: int, current_player: int):
	turn_label.text   = "Turn: %d"     % turn_number
	player_label.text = "Player: P%d"  % current_player
	
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
	

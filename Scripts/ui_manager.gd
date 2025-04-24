extends CanvasLayer
class_name UIManager

@onready var move_list: VBoxContainer = $Move_Options_Container/MoveOptions
@onready var turn_label      : Label  = $TurnPanel/VBoxContainer/TurnLabel
@onready var player_label    : Label  = $TurnPanel/VBoxContainer/PlayerLabel
@onready var end_turn_button : Button = $TurnPanel/VBoxContainer/EndTurnButton
@onready var confirm_container :PanelContainer = $Confirm_Container
var selection_mode_on : bool = false
var curr_targets : Array = []
var curr_move : Dictionary
var curr_move_alignment : String = ""
var move_source : Unit

var lm: Logic_Manager
func init(logic_manager)->void:
	lm = logic_manager
	_update_turn_display(lm.turn_number, lm.current_player)
	
func _on_end_turn_pressed() -> void:
	lm.turn_end()
	_update_turn_display(lm.turn_number, lm.current_player)
	
func _update_turn_display(turn_number: int, current_player: int):
	turn_label.text   = "Turn: %d"     % turn_number
	player_label.text = "Player: P%d"  % current_player
	
func send_data(ui_id: String, stats: Dictionary, moves: Dictionary, source : Unit) -> void:
	if(selection_mode_on) :
		if curr_move.targets_who == "enemy": #TODO other posible values
			if(source.team != curr_move_alignment):
				if curr_targets.size() < curr_move.max_targets:
					print("here")
					curr_targets.append(source)

	var lbl = Label.new()
	var text := ""
	for stat_name in stats.keys():
		text += "%s: %s\n" % [ stat_name.capitalize(), stats[stat_name]]
	lbl.text = text
	
	for child in move_list.get_children():
		child.queue_free()
	
	move_list.add_child(lbl)
	
	for move in moves.keys():
		var b = Button.new()
		b.text = str(move)
		b.pressed.connect(Callable(do_move).bind(moves.get(move), source))
		move_list.add_child(b)

func do_move(move: Dictionary, source : Unit) -> void:
	if(selection_mode_on) :
		cancel_selection_mode()
	selection_mode_on = true
	confirm_container.show()
	curr_move = move
	curr_move_alignment = source.team
	move_source = source
	
	pass
func cancel_selection_mode():
	curr_targets.clear()
	confirm_container.hide
	selection_mode_on = false


func _on_end_turn_button_pressed() -> void:
	pass # Replace with function body.


func _on_confirm_pressed() -> void:
	print(curr_targets)
	if(curr_targets.size() >= curr_move.min_targets):
		lm.do_effect(move_source, curr_move.function, curr_targets)
		cancel_selection_mode()


func _on_cancel_pressed() -> void:
	cancel_selection_mode()

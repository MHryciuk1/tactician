extends CanvasLayer
class_name UIManager

@onready var move_list: VBoxContainer = $Move_Options_Container/MoveOptions
@onready var turn_label      : Label  = $TurnPanel/VBoxContainer/TurnLabel
@onready var player_label    : Label  = $TurnPanel/VBoxContainer/PlayerLabel
@onready var end_turn_button : Button = $TurnPanel/VBoxContainer/EndTurnButton
@onready var confirm_container :PanelContainer = $Confirm_Container
@onready var confirm_container_progress : Label = $Confirm_Container/HBoxContainer/Progress
var selection_mode_on : bool = false
var curr_targets : Array = []
var curr_move : Dictionary
var curr_move_alignment : int = 0
var move_source : Unit

var lm: Logic_Manager
var grid : Hex_Grid
func init(logic_manager, hex_grid)->void:
	lm = logic_manager
	grid = hex_grid
	_update_turn_display(lm.turn_number, lm.current_player)
	
func _on_end_turn_pressed() -> void:
	lm.turn_end()
	_update_turn_display(lm.turn_number, lm.current_player)
	
func _update_turn_display(turn_number: int, current_player: int):
	turn_label.text   = "Turn: %d"     % turn_number
	player_label.text = "Player: P%d"  % current_player
func show_stats(ui_id: String, stats: Dictionary, moves: Dictionary, source : Unit) ->void:
	var lbl = Label.new()
	var text := ""
	for stat_name in stats.keys():
		text += "%s: %s\n" % [ stat_name.capitalize(), stats[stat_name]]
	lbl.text = text
	
	for child in move_list.get_children():
		child.queue_free()
	
	move_list.add_child(lbl)
func show_full_info(ui_id: String, stats: Dictionary, moves: Dictionary, source : Unit) -> void:
	show_stats(ui_id, stats, moves, source)
	
	for move in moves.keys():
		var move_dict : Dictionary = moves.get(move)
		var b = Button.new()
		b.text = str(move, " uses left: ", move_dict.uses_left)
		if(move_dict.uses_left > 0):
			b.pressed.connect(Callable(do_move).bind(move_dict, source))
		move_list.add_child(b)
func show_hex_data(hex : Vector2i) -> void :
	var data = grid.get_cell_data(hex)
	print(data)
func show_redacted_info(ui_id: String, stats: Dictionary, moves: Dictionary, source : Unit) -> void:
	show_stats(ui_id, stats, moves, source)
func handle_targeting(source : Unit) -> void:
	if curr_move.targets_who == "enemy": #TODO other posible values
			if(source.team != curr_move_alignment):
				if (curr_targets.size() < curr_move.max_targets) and (source.current_cord in grid.get_valid_spaces(move_source.current_cord,move_source.get_stats().attack_range)):
					print("here")
					curr_targets.append(source)
					confirm_container_progress.text = str(curr_targets.size(),"/",curr_move.max_targets, "minimum selection: ", curr_move.min_targets)
				else:
					print("invalid_target")
func enable_movement(source : Unit) -> void:
	if(source.team == lm.current_player) :
		move_source = source
		grid.enable_line_drawing_mode(source)
func disable_movement() -> void:
	grid.disable_line_drawing_mode()
func send_data(ui_id: String, stats: Dictionary, moves: Dictionary, source : Unit) -> void:
	if(not lm.actions_enabled):
		return
	if(selection_mode_on) :
		handle_targeting(source)
	else :
		enable_movement(source)
	if lm.current_player == source.team:
		show_full_info(ui_id, stats, moves, source)
	else:
		show_redacted_info(ui_id, stats, moves, source)
		
	

func do_move(move: Dictionary, source : Unit) -> void:
	if(selection_mode_on) :
		cancel_selection_mode()
	selection_mode_on = true
	confirm_container.show()
	curr_move = move
	curr_move_alignment = source.team
	move_source = source
	confirm_container_progress.text = str(curr_targets.size(),"/",curr_move.max_targets, "minimum selection: ", curr_move.min_targets)
	
	pass
func cancel_selection_mode():
	curr_targets.clear()
	confirm_container.hide()
	selection_mode_on = false


func _on_end_turn_button_pressed() -> void:
	lm.turn_end()

func _on_confirm_pressed() -> void:
	print(curr_targets)
	if(curr_targets.size() >= curr_move.min_targets):
		print("doing move")
		lm.do_effect(move_source, curr_move.function, curr_targets)
		curr_move.uses_left -=1
		cancel_selection_mode()


func _on_cancel_pressed() -> void:
	cancel_selection_mode()

extends Container #im being lay and just copying the layout code from card in the future i should just make a card container that only holds the layout logic
@onready var effect_text = $Card_Effect
@onready var art_node = $Card_Back
var top_margin : int = 3
var left_margin : int = 3
var right_margin : int = 3
var bottom_margin : int = 3
var card_image_start_y : int =100
var card_image_hight : int =500
var card : Node = null
var carHeld = ""
var in_craft : bool = false
var card_highlighted : bool = false
#var follow_mouse : bool = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = get_global_mouse_position()
func set_text(text: String) -> void:
	effect_text.text = text
func calculate_margins(top : float, bottom : float, left : float,right : float) -> void:
	var parent_size = get_parent_area_size()
	left_margin = parent_size.x * left
	#print(left_margin)
	right_margin = parent_size.x * right
	top_margin = parent_size.y * top
	bottom_margin = parent_size.y * bottom
func scale_object_to_size(obj : Node, new_size : Vector2) -> void :
	var new_scale : Vector2= Vector2(new_size.x/obj.size.x,new_size.y/obj.size.y)
	obj.scale= new_scale
func _notification(what):
	match what:
		NOTIFICATION_SORT_CHILDREN:
			
			var card_width = 128
			var card_hight = 192
			custom_minimum_size = Vector2(card_width+4,card_hight)
			var base_card_rect : Rect2 = Rect2(Vector2(0,0), Vector2(card_width,card_hight))
			var effect_text_start_percentage :float = .65
			fit_child_in_rect(art_node, base_card_rect)
			calculate_margins(.0075,.0075,.0075,.0075)
			var effect_text_position : float = card_hight*effect_text_start_percentage
			var card_effect_rect : Rect2 = Rect2(Vector2(left_margin, effect_text_position), Vector2(card_width-left_margin-right_margin,card_hight-effect_text_position-bottom_margin))
			var t = Rect2(card_effect_rect)
			t.size += Vector2(250,250)
			fit_child_in_rect(effect_text, t)
			scale_object_to_size(effect_text,card_effect_rect.size)
func set_in_craft() -> void:
	set_process(false)
	in_craft= true
func on_release() -> void:
	#if Game.current_card_idx ==-1 || card == null:
		#print("Whoops at CardHold/on_release")
	#if !Game.board.add_to_craft(card):
		#card.show()
	queue_free()
func _on_gui_input(event):
	if (event is InputEventMouseButton) and (event.button_index == 1):
		if event.button_mask == 1:
			pass
			#if card_highlighted:
				#Game.curr_card = self
				#set_process(true)
				#Game.cardSelected = true
				#Game.board.remove_from_craft()
				
						
		elif event.button_mask == 0:
			print("release")
			on_release()


func _on_card_back_mouse_entered():
	if in_craft:
		card_highlighted = true
		z_index = 1
		scale = Vector2(1.3,1.3)


func _on_card_back_mouse_exited():
	if in_craft:
		z_index = 0
		scale = Vector2(1,1)
	card_highlighted = false

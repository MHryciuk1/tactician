extends Container
#this is a node from a different project it will require some changes
#the logic engine is what i called the node that resolves all the card effects

#@export var eng_scene : PackedScene
@onready var card = load("res://Nodes/UI/CardHold.tscn")
const DMG_ID : int = 0
const REDUCE_ID : int = 1
const NX_ATK_ID : int = 3
const HEAL_ID : int = 5
var hand_idx : int = 0
var Deck_idx : int = 0

@onready var effect_text = $Card_Effect

@onready var art_node = $Card_Back
var top_margin : int = 3
var left_margin : int = 3
var right_margin : int = 3
var bottom_margin : int = 3

var card_image_start_y : int =100
var card_image_hight : int =500
var startPosition
var cardHighlighted = false
signal played

	
func _ready():
	pivot_offset.x = size.x/2
	pass
func get_texture() -> Texture:
	return art_node.texture	
func _on_mouse_entered():
	
	z_index = 1
	scale = Vector2(1.3,1.3)
	#$Animation.play("Select")
	cardHighlighted = true
func set_text(text: String) -> void:
	effect_text.text = text
func calculate_margins(top : float, bottom : float, left : float,right : float) -> void:
	var parent_size = get_parent_area_size()
	left_margin = parent_size.x * left
	#print(left_margin)
	right_margin = parent_size.x * right
	top_margin = parent_size.y * top
	bottom_margin = parent_size.y * bottom
func _on_mouse_exited():
	#$Animation.play("DeSelect")
	z_index = 0
	scale = Vector2(1,1)
	cardHighlighted = false
func on_release():
	pass
	#something similar may need to be implemented for our game but all the details wwill have to be different
	#if Game.selecting_for_crafting:
		#if !Game.board.add_to_craft(self):
			#show()
	#elif !Game.mouseOnPlacement:
				##print("mouse_out")
				#cardHighlighted = false
				#Game.curr_card = null
				#Game.current_card_idx = -1
				#show()
	#elif Game.board.placeCard(self):
		#Game.board.update_sprites()
		#Game.board.hand_container.update_hand()
		#Game.board.update_deck()
		#Game.board.update_discard()
		#Game.board.update_plays()
		#self.queue_free()
		##instantiate hand logic to subtract from hand instead of this doodoo for loop
	#for i in get_tree().get_root().get_node("Board/CardHolder").get_child_count():
		#get_tree().get_root().get_node("Board/CardHolder").get_child(i).queue_free()
	#
	#Game.cardSelected = false
#card draging was handled by hinding this node and instantiating a duplicate that would follow the mouse
func set_up_moving_card() -> void:
	var cardTemp = card.instantiate()
	get_tree().get_root().get_node("Board/CardHolder").add_child(cardTemp)
	cardTemp.art_node.texture = art_node.texture
	cardTemp.set_text(effect_text.text)
func _on_gui_input(event):
	#print(event)
	#we dont have a game node set up so this part will not work
	#if (event is InputEventMouseButton) and (event.button_index == 1):
		#if event.button_mask == 1:
			#Game.curr_card = self
			#if cardHighlighted:
				#set_up_moving_card()
				#Game.cardSelected = true
				#Game.current_card_idx = hand_idx
				#hide()
				##Game.board.add_to_craft(hand_idx)
				#
						#
		#elif event.button_mask == 0:
			#print("release")
			#on_release()
	pass
func scale_object_to_size(obj : Node, new_size : Vector2) -> void :
	var new_scale : Vector2= Vector2(new_size.x/obj.size.x,new_size.y/obj.size.y)
	obj.scale= new_scale
	
	#print(obj.scale)
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
			
			
			
			
			

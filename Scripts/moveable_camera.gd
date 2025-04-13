extends Camera2D
@export var speed = 1000
@export var zoom_step = .9

func _process(delta: float) -> void:
	var move_mod := Vector2(0,0)
	if Input.is_action_pressed("Left"):
		
		move_mod.x -= 1 
	if Input.is_action_pressed("Right"):
		move_mod.x += 1 
	if Input.is_action_pressed("Up"):
		move_mod.y -= 1 
	if Input.is_action_pressed("Down"):
		move_mod.y += 1 
	position+=(move_mod).normalized() * delta * speed
func  _input(event: InputEvent) -> void:
	if event.is_action("Zoom_In") :
		zoom = zoom * (zoom_step+.5)
	elif event.is_action("Zoom_Out"):
		zoom = zoom * (zoom_step)

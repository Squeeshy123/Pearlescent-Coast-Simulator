extends Camera2D

var velocity : Vector2 = Vector2.ZERO
var speed : float =  5

var Zoom_amount : float = 0.2

onready var map_ref : Sprite = get_tree().get_nodes_in_group("map")[0]

export var Zoom_curve : Curve

func _input(event):
	if Input.is_action_pressed("Zoom_in"):
		Zoom_amount += 0.0125
	if Input.is_action_pressed("Zoom_out"):
		Zoom_amount -= 0.0125
	
	if Input.is_action_just_pressed("Change_turn"):
		for i in get_tree().get_nodes_in_group("turn"):
			i.change_turn()
		
	


func get_input():
	velocity = Vector2.ZERO
	Zoom_amount = clamp(Zoom_amount, 0, 1)
	
	
	if Input.is_action_pressed("Down"):
		velocity.y += 1
	if Input.is_action_pressed("Up"):
		velocity.y -= 1
	if Input.is_action_pressed("Left"):
		velocity.x -= 1
	if Input.is_action_pressed("Right"):
		velocity.x += 1
	
	
	Zoom_amount = clamp(Zoom_amount, Zoom_curve.min_value, Zoom_curve.max_value)
	
func _process(delta):
	get_input()
	
	position.x = clamp(position.x, -3840, 3840)
	position.y = clamp(position.y, -1820, 1820)
	position += velocity * speed * Zoom_curve.interpolate(Zoom_amount)
	
	zoom = Vector2(Zoom_curve.interpolate(Zoom_amount), Zoom_curve.interpolate(Zoom_amount))

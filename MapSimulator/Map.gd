extends Node2D

export var path : PoolVector2Array

func _ready():
	pass 

func _input(event):
	if Input.is_action_just_pressed("add_point"):
		path.append(get_global_mouse_position() - position)
		print(path)
		update()

func _draw():
	for i in path:
		draw_circle(i, 10, Color(1,1,0,1))
	print(path)

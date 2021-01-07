tool
extends Node2D

export var path : PoolVector2Array

func _ready():
	pass 

func _input(event):
	if Input.is_action_just_pressed("add_point"):
		path.append(get_global_mouse_position())
		print(path)
	

func _draw():
	for i in range(0, path.size()-1):
		draw_circle(path[i], 5, Color.black)
		print(path[i])

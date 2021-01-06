extends Node2D

onready var camera = get_tree().get_nodes_in_group("Camera")[0]

var mouse_in : bool = false

var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$Sprite.scale = Vector2(1.1 - camera.Zoom_amount, 1.1 - camera.Zoom_amount) * 5
	$Area2D.scale = Vector2(1.1 - camera.Zoom_amount, 1.1 - camera.Zoom_amount) * 2
	if mouse_in:
		pass

func _input(event):
	if Input.is_action_just_pressed("Click"):
			#Put Click Logic
		pass


func _on_Area2D_mouse_entered():
	mouse_in = true


func _on_Area2D_mouse_exited():
	mouse_in = false

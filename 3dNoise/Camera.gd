extends Spatial


onready var camera = $Camera
var mouse_sens = 0.005

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	if Input.is_action_pressed("Zoom_out"):
		camera.translate(Vector3(0,0,1))
	if Input.is_action_pressed("Zoom_in"):
		camera.translate(Vector3(0,0,-1))

func _input(event):
	get_input()
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sens)
		rotate_x(-event.relative.y * mouse_sens)
		rotation.z = 0
	if Input.is_action_just_pressed("Click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("Click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

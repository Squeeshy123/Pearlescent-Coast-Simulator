extends KinematicBody

onready var camera = $Pivot/Camera
onready var pivot = $Pivot
var gravity = -30
var max_speed = 32
var mouse_sensitivity = 0.002  # radians/pixel

onready var chunk_size = get_parent().chunk_size

var velocity = Vector3()

func _process(delta):
#	get_parent().fill_grid(translation.snapped(Vector3(chunk_size,chunk_size,chunk_size)))
	pass
func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("Up"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("Down"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("Left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("Right"):
		input_dir += camera.global_transform.basis.x
	if Input.is_action_pressed("st_up"):
		velocity.y = 25
	elif Input.is_action_pressed("st_down"):
		velocity.y = -25
	else:
		velocity.y = 0
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if Input.is_action_just_pressed("Click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -1.5, 1.5)

func _physics_process(delta):
#	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)

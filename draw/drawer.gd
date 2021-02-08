extends Node2D

var circles = []

onready var p1 = $p1
onready var p2 = $p2
onready var p3 = $p3
onready var p4 = $p4
onready var p5 = $p5
onready var p6 = $p6
onready var p7 = $p7
onready var p8 = $p8

var center = Vector2(512,300)

func rotate_point(px, py, angle): 
	var s = sin(angle);
	var c = cos(angle);

	px -= center.x;
	py -= center.y;
	
	var xnew = px * c - py * s;
	var ynew = px * s + py * c;
	
	px = xnew + center.x;
	py = ynew + center.y;
	
	return Vector2(px, py);


func _process(delta):
	print(center)
	update()

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("Click"):
		var mouse_pos = event.position
		
		p1.add_point(mouse_pos)
		p2.add_point(rotate_point(mouse_pos.x, event.position.y, 45))
		p3.add_point(rotate_point(mouse_pos.x, event.position.y, 45 * 2))
		p4.add_point(rotate_point(mouse_pos.x, event.position.y, 45 * 3))
		p5.add_point(rotate_point(mouse_pos.x, event.position.y, 45 * 4))
		p6.add_point(rotate_point(mouse_pos.x, event.position.y, 45 * 5))
#		p7.add_point(rotate_point(mouse_pos.x, event.position.y, 45 * 6))
		update()

func _draw():
	for i in circles:
		draw_circle(i, 5, Color.black)

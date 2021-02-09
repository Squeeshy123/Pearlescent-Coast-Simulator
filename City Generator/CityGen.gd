extends Node2D

var margin = Vector2(250,100)
var point_amount = 100
var points =  []
var points_color = []
var point_range = Vector2(700,400)
var point_res = 6
var cell_res = point_res * 2

var has_generated = false

var point_mutex
var point_thread

var cell_thread
var cell_mutex
func generate():
	points.clear()
	points_color.clear()
	randomize()
	point_thread = Thread.new()
	generate_points("a")
	update()

func generate_points(a):
	point_mutex = Mutex.new()
	var size = 10
	for x in range(point_amount/2):
		for y in range(point_amount/2):
			point_mutex.lock()
			points.append(Vector2(x*size,y*size))
			points_color.append(Color(rand_range(0,1),rand_range(0,1),rand_range(0,1)))
			point_mutex.unlock()

var n = 0

func generate_cells(a):
	cell_mutex = Mutex.new()
	for x in range((point_range.x)/point_res):
		for y in range((point_range.y)/point_res):
			n = 0
			for i in range(points.size()-1):
				cell_mutex.lock()
				if distance(points[i].x, x * point_res, points[i].y, y * point_res) < distance(points[n].x, x * point_res, points[n].y, y * point_res):
					n = i
				cell_mutex.unlock()
			draw_rect(Rect2(Vector2(x * point_res,y * point_res),Vector2(cell_res/2,cell_res/2)), points_color[n])
#	update()
func _draw():
	if has_generated:
		generate_cells("a")
		
		for i in points:
			draw_circle(i, 2, Color.black)


func distance(x1, x2, y1, y2): 
	var d 
#	d = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)); # Euclidian
	d = abs(x1 - x2) + abs(y1 - y2) # Manhattan
#	d = pow(pow(abs(x1 - x2), p) + pow(abs(y1 - y2), p), (1 / p)) # Minkovski
	return d


func _on_Button_button_down():
	has_generated = true
	generate()


func _on_LineEdit_text_entered(new_text):
	point_res = float(new_text)
	cell_res = point_res * 2
	print(cell_res)

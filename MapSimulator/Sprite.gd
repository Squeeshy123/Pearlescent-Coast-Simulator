extends Sprite


var points
var point_ind = 0
var speed = 500

func _ready():
	points = get_parent().curve.tessellate(2)
	position = points[point_ind]

func _process(delta):
	if point_ind+1 > points.size()-1:
		point_ind = 0
	else:
		position += position.direction_to(points[point_ind]) * speed * delta
	if position.distance_to(points[point_ind]) < 5:
		point_ind += 1

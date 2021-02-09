extends Spatial

onready var gridmap = $GridMap

var noise = OpenSimplexNoise.new()
var chunk_size = 50
var size = Vector3(chunk_size,chunk_size,chunk_size)

var cull_amount = 0.1

var loaded_chunks = []
var preloaded_chunks = [Vector3(0,0,0),Vector3(0,0,1),Vector3(0,1,0),Vector3(-1,0,0),Vector3(0,0,-1),Vector3(0,-1,0),Vector3(-1,0,0)]
var g_thread
var cell_size = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	noise.octaves = 8
	noise.period = 20.0
	noise.persistence = rand_range(0.01,0.5)
	noise.lacunarity = 0.1
	
	for i in preloaded_chunks:
		g_thread = Thread.new()
		g_thread.start(self, "fill_grid", i*chunk_size)
		g_thread.wait_to_finish()
#	cull_unseen()

func _input(event):
	if Input.is_action_just_pressed("Change_turn"):
		cull_unseen()

func fill_grid(offset):
	var grid_mutex = Mutex.new()
	if !loaded_chunks.has(offset):
		for x in range(size.x):
			for y in range(size.y):
				for z in range(size.z):
					if noise.get_noise_3d(x + offset.x,y + offset.y,z + offset.z) < cull_amount:
#						if get_near_cells(Vector3(x,y,z)) == 6:
						gridmap.set_cell_item(x - size.x/2 + offset.x, y - size.y/2 + offset.y, z - size.z/2 + offset.z, 0)
#						multimesh.instance_count += 1
#						multimesh.set_instance_transform(x*y*z, Transform(Basis(Vector3.ONE),Vector3(x,y,z)*cell_size))
#		grid_mutex.lock()
		loaded_chunks.append(offset)
#		grid_mutex.unlock()

func cull_unseen():
	for i in gridmap.get_used_cells():
		if get_near_cells(i) == 6:
			gridmap.set_cell_item(i.x, i.y, i.z, -1)

func get_near_cells(cell_pos):
	var count = 0
	#up
	if gridmap.get_cell_item(cell_pos.x, cell_pos.y + 1, cell_pos.z) != -1:
		count += 1
	#down
	if gridmap.get_cell_item(cell_pos.x, cell_pos.y + -1, cell_pos.z) != -1:
		count += 1
	#right
	if gridmap.get_cell_item(cell_pos.x + 1, cell_pos.y, cell_pos.z) != -1:
		count += 1
	#left
	if gridmap.get_cell_item(cell_pos.x - 1, cell_pos.y, cell_pos.z) != -1:
		count += 1
	#forward
	if gridmap.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z + 1) != -1:
		count += 1
	#back
	if gridmap.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z - 1) != -1:
		count += 1
	return count

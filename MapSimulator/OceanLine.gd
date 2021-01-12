extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mesh = $Map_outline.mesh

var arr = []


var mdt = MeshDataTool.new() 
onready var nd = get_node("Map_outline")
onready var m = nd.get_mesh()
#get surface 0 into mesh data tool)

onready var verts : PoolVector2Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	mdt.create_from_surface(m, 0)
	verts.resize(mdt.get_vertex_count())
	for vtx in range(mdt.get_vertex_count()):
		verts[vtx] = Vector2(mdt.get_vertex(vtx).x, mdt.get_vertex(vtx).y)
		#print("global vertex: "+str(nd.global_transform.xform(vert))
	
	$CollisionPolygon2D.polygon = verts


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

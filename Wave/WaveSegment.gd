extends ImmediateGeometry

var length = 1.0;
var width = 1.0;
var front_height = 0;
var back_height = 0;
var speed = 5;
var position = Vector3()
var material = null

func _ready():
	set_process(true)

func _process(delta):
	
	var front_left = position + Vector3(-width/2, front_height, -length/2)
	var front_right = position + Vector3(width/2, front_height, -length/2)
	var back_left = position + Vector3(width/2, back_height, length/2)
	var back_right = position + Vector3(-width/2, back_height, length/2)
	
	self.clear()
	self.begin(VS.PRIMITIVE_TRIANGLES, null)
	self.set_material_override(material)
	# Top side of triangle one
	self.add_vertex(front_left)
	self.add_vertex(front_right)
	self.add_vertex(back_right)
	# Bottom side of triangle one (basically the same as the top but reverse order.)
	self.add_vertex(back_right)
	self.add_vertex(front_right)
	self.add_vertex(front_left)
	# Top side of triangle two
	self.add_vertex(front_right)
	self.add_vertex(back_left)
	self.add_vertex(back_right)
	# Bottom side of triangle two
	self.add_vertex(back_right)
	self.add_vertex(back_left)
	self.add_vertex(front_right)
	self.end()

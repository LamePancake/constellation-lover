extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var last_x = 0
var last_y = 0
var last_z = 0
export var accel_x = 0.0
export var accel_y = 0.0
export var accel_z = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	var origin = get_transform().origin
	last_x = origin.x
	last_y = origin.y
	last_z = origin.z

func get_pos():
	return get_transform().origin

func _fixed_process(delta):
	var origin = get_transform().origin
	var x = origin.x
	var y = origin.y
	var z = origin.z
	
	var vel_x = x - last_x
	var vel_y = y - last_y
	var vel_z = z - last_z
	
	var next_x = x + vel_x + accel_x * delta
	var next_y = y + vel_y + accel_y * delta
	var next_z = z + vel_z + accel_z * delta
	
	last_x = x
	last_y = y
	last_z = z
	
	var offset_x = next_x - x
	var offset_y = next_y - y
	var offset_z = next_z - z
	
	global_translate(Vector3(offset_x, offset_y, offset_z))


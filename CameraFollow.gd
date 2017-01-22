extends Camera

export var jumping_fov = 60.0
var normal_fov = 120.0
export var lerp_speed = 8.0

var kite = null

func _ready():
	kite = get_node("/root/Game/Kite")
	normal_fov = get_fov()
	set_fixed_process(true)
	set_process(true)
	
func _fixed_process(delta):
	var cur_pos = get_translation()
	var kite_pos = kite.get_translation()
	set_translation(Vector3(lerp(cur_pos.x, kite_pos.x, 0.5), cur_pos.y, cur_pos.z))
	
func _process(delta):
	if (kite.is_ascending || kite.is_descending):
		set_perspective(lerp(get_fov(), jumping_fov, lerp_speed * delta), get_znear(), get_zfar())
	else:
		set_perspective(lerp(get_fov(), normal_fov, lerp_speed * delta), get_znear(), get_zfar())
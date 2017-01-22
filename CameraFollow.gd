var kite = null

func _ready():
	kite = get_node("/root/Game/Kite")
	set_fixed_process(true)
	
func _fixed_process(delta):
	var cur_pos = get_translation()
	var kite_pos = kite.get_translation()
	set_translation(Vector3(lerp(cur_pos.x, kite_pos.x, 0.5), cur_pos.y, cur_pos.z))
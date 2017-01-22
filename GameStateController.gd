var kite = null
var initial_position = 0
var initial_rotation = 0

var minimum_bound = -5

var elapsed_time = 0

func _ready():
	kite = get_node("/root/Game/Kite")
	initial_position = kite.get_translation()
	initial_rotation = kite.get_rotation()
	set_process(true)
	
func _process(delta):
	elapsed_time += delta
	if (kite.get_translation().y < minimum_bound):
		kite.set_translation(initial_position)
		kite.set_rotation(initial_rotation)

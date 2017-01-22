extends Node

var kite = null
var wave = null

func _ready():
	kite = get_node("/root/Game/Kite")
	wave = get_node("/root/Game/Wave")
	set_process(true)
	
func _process(delta):
	var first_segment = wave.wave_segment_array[0]
	var pos = kite.get_translation()
	pos.y = first_segment.back_height
	kite.set_translation(pos)

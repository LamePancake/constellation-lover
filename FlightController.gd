extends Node

var kite = null
var wave = null

func _ready():
	kite = get_node("/root/Game/Kite")
	wave = get_node("/root/Game/Wave")
	set_process(true)
	
func _process(delta):
	var pos = kite.get_translation()
	pos.y = wave.get_height(pos.z)
	kite.set_translation(pos)

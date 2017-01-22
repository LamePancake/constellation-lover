extends Node

export(NodePath) var start_wave = NodePath("/root/Game/CentreWave")

export var drop_speed = 1.0

var kite = null
var wave = null

func _ready():
	kite = get_node("/root/Game/Kite")
	wave = get_node(start_wave)
	
	# Set the initial position
	var pos = kite.get_translation()
	pos.x = wave.get_translation().x
	pos.y = wave.get_height(pos.z)
	kite.set_translation(pos)
	set_process(true)
	
func _process(delta):
	var kite_pos = kite.get_translation()
	var should_drop = false
	
	var wave_group = get_tree().get_nodes_in_group("Waves")
	wave = null
	
	# If we're over a wave, set the kite's height to the corresponding wave
	# height; otherwise, start dropping the kite
	for node in wave_group:
		var wave_width = node.wave_segment_array[0].width
		var wave_left_side = node.get_translation().x - wave_width / 2.0
		var wave_right_side = node.get_translation().x + wave_width / 2.0
		
		if(kite_pos.x >= wave_left_side and kite_pos.x <= wave_right_side):
			wave = node
	
	if(wave != null):
		var height = wave.get_height(kite_pos.z)
		
		var segment = wave.get_segment(kite_pos.z)
		if (wave.gaps.size() > 0):
			for gap in wave.gaps:
				var gap_segments = wave.get_gap_segments(gap)
				if (gap_segments.has(segment)):
					should_drop = true
		
		# Determine if we should lift the kite
		if(!should_drop):
			if(kite_pos.y < height):
				var diff = height - kite_pos.y
				if (diff < wave.lift_radius):
					kite_pos.y += delta * wave.lift_speed
				else:
					should_drop = true
			else:
				kite_pos.y = height
	else:
		should_drop = true

	if (should_drop):
		kite_pos.y -= delta * drop_speed

	kite.set_translation(kite_pos)

extends Node

const WaveSegmentScene = preload("res://Wave/WaveSegment.tscn")

var number_of_wave_segments = 2
var wave_segment_array = Array()
var height = 0


func _ready():
	set_process(true)
	# Place a bunch of wave segments that will form the wave.
	var position = Vector3();
	for i in range(number_of_wave_segments):
		var seg = WaveSegmentScene.instance();
		# Wave segments are offset from each other using their lengths.
		# Currently this is hardcoded in the WaveSegment script
		position.z -= seg.length;
		seg.position = position
		
		wave_segment_array.push_back(seg)
		add_child(seg)

func _process(delta):
	var seg1 = wave_segment_array[0]
	var seg2 = wave_segment_array[1]
	
	height += 2 * delta;
	seg1.front_height = height;
	seg2.back_height = height;
	
	if height > 2:
		height = 0
	
        

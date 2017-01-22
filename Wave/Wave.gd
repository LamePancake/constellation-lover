extends Node

const WaveSegmentScene = preload("res://Wave/WaveSegment.tscn")

var number_of_wave_segments = 6
var wave_segment_array = Array()
var height = 0
var total_length = 0.0

export var wave_vel = 7.0
export var wave_start = 0.0

func get_height(z_pos):
	var mapped_segment_size = PI * 2 / total_length
	var start = wave_segment_array[0].position.z + wave_segment_array[0].length
	var offset = start
	
	
func get_segment_heights(segment, segment_num):
	# Get the front and back heights for this segment
	
	var back_z = segment_num
	var front_z = ((segment_num + 1) * mapped_size) + wave_start
	
	var back_height = sin(back) / 2
	var front_height = sin(front) / 2
	
	return [front_height, back_height]
	
func _ready():
	set_process(true)
	# Place a bunch of wave segments that will form the wave.
	var position = Vector3();
	for i in range(number_of_wave_segments):
		var seg = WaveSegmentScene.instance();
		# Wave segments are offset from each other using their lengths.
		# Currently this is hardcoded in the WaveSegment script
		position.z -= seg.length
		seg.position = position
		
		total_length += seg.length
		
		wave_segment_array.push_back(seg)
		add_child(seg)

func _process(delta):
	for i in range(number_of_wave_segments):
		var seg = wave_segment_array[i]
		var seg_heights = get_segment_heights(seg, i)
		seg.front_height = seg_heights[0]
		seg.back_height = seg_heights[1]
	
	wave_start += delta * wave_vel
	
        

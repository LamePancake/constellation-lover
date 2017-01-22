extends Node

const WaveSegmentScene = preload("res://Wave/WaveSegment.tscn")

var number_of_wave_segments = 6
var wave_segment_array = Array()
var height = 0

var wave_vel = 10.0
var wave_start = 0.0

# Length of each segment is fixed
# Centre of each segment is fixed
# Add pi/6 (30 degrees) per segment to start
# Start = sin(0), next = sin(pi / 6), next = sin(

func get_segment_heights(segment, segment_num):
	# Get the front and back heights for this segment
	
	var wave_length = number_of_wave_segments * segment.length
	var mapped_size = PI * 2 / wave_length
	var back = (segment_num * mapped_size) + wave_start
	var front = ((segment_num + 1) * mapped_size) + wave_start
	
	var back_height = sin(back)
	var front_height = sin(front)
	
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
		
		wave_segment_array.push_back(seg)
		add_child(seg)

func _process(delta):
	for i in range(number_of_wave_segments):
		var seg = wave_segment_array[i]
		var seg_heights = get_segment_heights(seg, i)
		seg.front_height = seg_heights[0]
		seg.back_height = seg_heights[1]
	
	wave_start += delta * wave_vel
	
        

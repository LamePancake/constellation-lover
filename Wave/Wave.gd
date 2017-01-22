extends Node

const WaveSegmentScene = preload("res://Wave/WaveSegment.tscn")

var number_of_wave_segments = 6
var wave_segment_array = Array()
var height = 0
var total_length = 0.0

export var wave_vel = 7.0
export var wave_start = 0.0

func get_height(z_pos):
	# Maps this wave in the range 0->PI/2
	var mapped_segment_size = PI * 2 / total_length
	
	# Calculate where this z position falls along the mapped line
	var start = wave_segment_array[0].position.z + wave_segment_array[0].length
	var pos = start - z_pos + wave_start
	return sin(pos * mapped_segment_size) / 2.0
	
func set_segment_heights(segment):
	# Get the front and back z-coordinates for this segment
	# Front is in the -z direction
	var back_z = segment.position.z + (segment.length / 2)
	var front_z = segment.position.z - (segment.length / 2)
	
	segment.back_height = get_height(back_z)
	segment.front_height = get_height(front_z)
	
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
	# Adjust the segments' heights
	for i in range(number_of_wave_segments):
		set_segment_heights(wave_segment_array[i])
	
	wave_start += delta * wave_vel
	
        

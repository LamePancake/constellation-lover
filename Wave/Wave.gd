extends Node

const WaveSegmentScene = preload("res://Wave/WaveSegment.tscn")

var number_of_wave_segments = 6
var wave_segment_array = Array()
var height = 0
var total_length = 0.0

# Gap settings and current state
export(Vector2) var gap_frequency_range = Vector2(1.0, 3.0)
export var gap_size = 2
export var gap_speed = 2.0

const GAP_POS_INDEX = 0
const GAP_SIZE_INDEX = 1
var gaps = Array()
var next_gap_time = 0.0

export var wave_vel = 6.0
export var wave_start = 0.0

export var lift_radius = 0.5
export var lift_speed = 3.0

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

func create_gap():
	var last_segment = wave_segment_array[number_of_wave_segments - 1]
	var last_segment_front = last_segment.position.z - last_segment.length / 2.0
	var gap = [last_segment_front, gap_size]
	
	return gap

func update_gaps(delta):
	var gaps_to_remove = Array()
	
	# Move the gaps along the wave, making any segments they contain invisible
	for gap in gaps:
		gap[GAP_POS_INDEX] += gap_speed * delta
		var segments = get_gap_segments(gap)
		if (segments.size() == 0):
			gaps_to_remove.push_back(gap)
		else:
			#for segment in segments:
			#	segment.set_visible(false)
			pass

	# Remove any gaps that have gone offscreen
	for gap in gaps_to_remove:
		gaps.erase(gap)
	
	next_gap_time -= delta
	if(next_gap_time <= 0.0):
		gaps.push_back(create_gap())
		next_gap_time = rand_range(gap_frequency_range.x, gap_frequency_range.y)

func get_gap_segments(gap):
	var segments = Array()
	var gap_segment = get_segment(gap[GAP_POS_INDEX])
	var segment_index = wave_segment_array.find(gap_segment)
	if(gap_segment != null):
		var start = max(segment_index - gap[GAP_SIZE_INDEX], 0)
		for j in range(start, segment_index + 1):
			segments.push_back(wave_segment_array[j])
	
	return segments

func get_segment(z_pos):
	for segment in wave_segment_array:
		var segment_front = segment.position.z - segment.length / 2.0
		var segment_back = segment.position.z + segment.length / 2.0
		
		if(z_pos >= segment_front and z_pos <= segment_back):
			return segment
	
	return null

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
	
	next_gap_time = rand_range(gap_frequency_range.x, gap_frequency_range.y)

func _process(delta):
	# Adjust the segments' heights
	for i in range(wave_segment_array.size()):
		set_segment_heights(wave_segment_array[i])
	
	update_gaps(delta)    
	
	wave_start += delta * wave_vel    

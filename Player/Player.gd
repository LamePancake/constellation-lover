var lateral_speed = 2
var ascending_speed = 2
var descending_speed = -1.5

var jump_height = 1.5
var resting_height = 0

var is_ascending = false
var is_descending = false

func _ready():
	resting_height = get_translation().y
	set_fixed_process(true)
	
func _fixed_process(delta):
	var cur_pos = get_translation()
	
	if (Input.is_action_pressed("MOVE_LEFT")):
		move(Vector3(-lateral_speed * delta, 0, 0))
		
	if (Input.is_action_pressed("MOVE_RIGHT")):
		move(Vector3(lateral_speed * delta, 0, 0))
		
	if (Input.is_action_pressed("JUMP") && !is_ascending && !is_descending):
		is_ascending = true
		
	if (is_ascending):
		move(Vector3(0, ascending_speed * delta, 0))
		if (cur_pos.y >= jump_height + resting_height):
			is_ascending = false
			is_descending = true
	
	if (is_descending):
		move(Vector3(0, descending_speed * delta, 0))
		if (cur_pos.y <= resting_height):
			is_ascending = false
			is_descending = false
			set_translation(Vector3(cur_pos.x, resting_height, cur_pos.z))
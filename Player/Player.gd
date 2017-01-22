var lateral_speed = 1.5
var ascending_speed = 2
var descending_speed = -1.5

var lateral_rotation_speed = 0.5
var vertical_rotation_speed = 0.9

var max_lateral_angualar_velocity = 0.4
var min_lateral_angular_velocity = 0.02

var max_vertical_angular_velocity = 3
var min_vertical_angular_velocity = 0

var cur_lateral_velocity = 0
var cur_lateral_angular_velocity = 0
var cur_vertical_angular_velocity = 0

var jump_height = 1.5
var resting_height = 0

var is_ascending = false
var is_descending = false
var is_moving_left = false
var is_moving_right = false

func _ready():
	resting_height = get_translation().y
	set_fixed_process(true)
	
func _fixed_process(delta):
	var cur_pos = get_translation()
	var cur_rot = get_rotation()
	_process_input()
	_update_lateral_movement(delta, cur_pos, cur_rot)
	
	if (is_ascending):
		move(Vector3(0, ascending_speed * delta, 0))
		if (cur_vertical_angular_velocity > -max_vertical_angular_velocity):
			cur_vertical_angular_velocity += -vertical_rotation_speed * delta
			rotate_x(-vertical_rotation_speed * delta)
		if (cur_pos.y >= jump_height + resting_height):
			is_ascending = false
			is_descending = true
	elif (is_descending):
		move(Vector3(0, descending_speed * delta, 0))
		if (cur_vertical_angular_velocity < min_vertical_angular_velocity):
			cur_vertical_angular_velocity += vertical_rotation_speed * delta
			rotate_x(vertical_rotation_speed * delta)
		if (cur_pos.y <= resting_height):
			is_ascending = false
			is_descending = false
			set_translation(Vector3(cur_pos.x, resting_height, cur_pos.z))
		
func _process_input():
	if (Input.is_action_pressed("MOVE_LEFT")):
		is_moving_left = true
		is_moving_right = false
	else:
		is_moving_left = false
		
	if (Input.is_action_pressed("MOVE_RIGHT")):
		is_moving_left = false
		is_moving_right = true
	else:
		is_moving_right = false

	if (Input.is_action_pressed("JUMP") && !is_ascending && !is_descending):
		is_ascending = true

func _update_lateral_movement(delta, cur_pos, cur_rot):
	if (is_moving_left):
		cur_lateral_velocity += -lateral_speed * delta;
		move(Vector3(-lateral_speed * delta, 0, 0))
		if (cur_lateral_angular_velocity > -max_lateral_angualar_velocity):
			cur_lateral_angular_velocity += -lateral_rotation_speed * delta
			rotate_z(-lateral_rotation_speed * delta)
	elif (is_moving_right):
		cur_lateral_velocity += lateral_speed * delta;
		move(Vector3(lateral_speed * delta, 0, 0))
		if (cur_lateral_angular_velocity < max_lateral_angualar_velocity):
			cur_lateral_angular_velocity += lateral_rotation_speed * delta
			rotate_z(lateral_rotation_speed * delta)
	else :
		if (cur_lateral_velocity > 0):
			cur_lateral_velocity += lateral_speed * delta;
			move(Vector3(lateral_speed * delta, 0, 0))
		elif (cur_lateral_velocity < 0):
			cur_lateral_velocity += -lateral_speed * delta;
			move(Vector3(-lateral_speed * delta, 0, 0))
		if (cur_lateral_angular_velocity > 0):
			cur_lateral_angular_velocity += -lateral_rotation_speed * delta
			rotate_z(-lateral_rotation_speed * delta)
		elif (cur_lateral_angular_velocity < 0):
			cur_lateral_angular_velocity += lateral_rotation_speed * delta
			rotate_z(lateral_rotation_speed * delta)
		if ((cur_lateral_angular_velocity < min_lateral_angular_velocity) && (cur_lateral_angular_velocity > -min_lateral_angular_velocity)):
			cur_lateral_angular_velocity = 0
			set_rotation(Vector3(cur_rot.x, cur_rot.y, 0))
			cur_lateral_velocity = 0
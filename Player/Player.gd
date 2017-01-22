var horizontal_speed = 1.5
var horizontal_stabilization_speed = 1
var ascending_speed = 2
var descending_speed = -1.5

var horizontal_rot_speed = 0.5
var vertical_rot_speed = 0.9

var max_horizontal_angualar_velocity = 0.4
var min_horizontal_angular_velocity = 0.02

var max_vertical_angular_velocity = 3
var min_vertical_angular_velocity = 0

var cur_horizontal_velocity = 0
var cur_horizontal_angular_velocity = 0
var cur_vertical_angular_velocity = 0

var jump_amount = 1.5
var resting_height = 0
var resting_rot = 0

var is_ascending = false
var is_descending = false
var is_moving_left = false
var is_moving_right = false

var left = -1.0
var right = 1.0

func _ready():
	resting_height = get_translation().y
	resting_rot = get_rotation()
	set_fixed_process(true)

func _fixed_process(delta):
	var cur_pos = get_translation()
	var cur_rot = get_rotation()
	
	_process_input()
	_update_horizontal_movement(delta, cur_pos, cur_rot)
	_update_vertical_movement(delta, cur_pos, cur_rot)

func _process_input():
	if (Input.is_action_pressed("MOVE_LEFT") && !is_moving_right):
		is_moving_left = true
		is_moving_right = false
	else:
		is_moving_left = false

	if (Input.is_action_pressed("MOVE_RIGHT") && !is_moving_left):
		is_moving_left = false
		is_moving_right = true
	else:
		is_moving_right = false

	if (Input.is_action_pressed("JUMP") && !is_ascending && !is_descending):
		is_ascending = true

func _update_horizontal_movement(delta, cur_pos, cur_rot):
	
	var delta_velocity = horizontal_speed * delta;
	var delta_angular_velocity = horizontal_rot_speed * delta
	
	if (is_moving_left):
		#move kite left
		cur_horizontal_velocity += left * delta_velocity
		move(Vector3(left * delta_velocity, 0, 0))
		
		#rotate kite left
		if (cur_horizontal_angular_velocity > left * max_horizontal_angualar_velocity):
			cur_horizontal_angular_velocity += left * delta_angular_velocity
			rotate_z(left * delta_angular_velocity)
			
	elif (is_moving_right):
		#move kite right
		cur_horizontal_velocity += right * delta_velocity;
		move(Vector3(right * delta_velocity, 0, 0))
		
		#rotate kite right
		if (cur_horizontal_angular_velocity < right * max_horizontal_angualar_velocity):
			cur_horizontal_angular_velocity += right * delta_angular_velocity
			rotate_z(right * delta_angular_velocity)
			
	else :
		
		var stabilization_delta_velocity = horizontal_stabilization_speed * delta
		
		if (cur_horizontal_velocity > 0):
			move(Vector3(stabilization_delta_velocity, 0, 0))
			
		elif (cur_horizontal_velocity < 0):
			move(Vector3(-stabilization_delta_velocity, 0, 0))
			
		if (cur_horizontal_angular_velocity > 0):
			cur_horizontal_angular_velocity -= delta_angular_velocity
			rotate_z(-delta_angular_velocity)
			
		elif (cur_horizontal_angular_velocity < 0):
			cur_horizontal_angular_velocity += delta_angular_velocity
			rotate_z(delta_angular_velocity)
			
		if ((cur_horizontal_angular_velocity < min_horizontal_angular_velocity) && (cur_horizontal_angular_velocity > -min_horizontal_angular_velocity)):
			cur_horizontal_angular_velocity = 0
			cur_horizontal_velocity = 0
			set_rotation(Vector3(cur_rot.x, cur_rot.y, resting_rot.z))
			
func _update_vertical_movement(delta, cur_pos, cur_rot):
	
	var delta_ascending = ascending_speed * delta
	var delta_descending = descending_speed * delta
	var delta_angular_velocity =  vertical_rot_speed * delta
	
	if (is_ascending):
		set_rotation(Vector3(cur_rot.x, resting_rot.y, resting_rot.z))
		cur_horizontal_angular_velocity = 0
		
		move(Vector3(0, delta_ascending, 0))
		
		if (cur_vertical_angular_velocity > -max_vertical_angular_velocity):
			cur_vertical_angular_velocity -=delta_angular_velocity
			rotate_x(-delta_angular_velocity)
			
		if (cur_pos.y >= jump_amount + resting_height):
			is_ascending = false
			is_descending = true
			
	elif (is_descending):
		set_rotation(Vector3(cur_rot.x, resting_rot.y, resting_rot.z))
		cur_horizontal_angular_velocity = 0
		
		move(Vector3(0, delta_descending, 0))
		
		if (cur_vertical_angular_velocity < min_vertical_angular_velocity):
			cur_vertical_angular_velocity += delta_angular_velocity
			rotate_x(delta_angular_velocity)
			
		if (cur_pos.y <= resting_height):
			is_ascending = false
			is_descending = false
			set_translation(Vector3(cur_pos.x, resting_height, cur_pos.z))
			set_rotation(Vector3(resting_rot.x, cur_rot.y, cur_rot.z))

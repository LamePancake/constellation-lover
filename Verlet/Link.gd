tool
extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var p_1_path = NodePath()
export var p_2_path = NodePath()
var p_1
var p_2
var resting_difference = 0.8

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	p_1 = get_node(p_1_path)
	p_2 = get_node(p_2_path)

func solve_constraints():
	var diff_x = p_1.get_pos().x - p_2.get_pos().x
	var diff_y = p_1.get_pos().y - p_2.get_pos().y
	var diff_z = p_1.get_pos().z - p_2.get_pos().z
	var distance = sqrt(diff_x * diff_x + diff_y * diff_y + diff_z * diff_z)
	
	# scalar difference
	var difference = (resting_difference - distance) / distance
	
	var trans_x = diff_x * 0.5 * difference
	var trans_y = diff_y * 0.5 * difference
	var trans_z = diff_z * 0.5 * difference
	
	#var p_1_x = p_1.get_pos().x + trans_x
	#var p_1_y = p_1.get_pos().y + trans_y
	p_1.global_translate(Vector3(trans_x, trans_y, trans_z))
	#p_1.set_pos(Vector3(p_1_x, p_1_y, p_1.get_pos().z))
	
	#var p_2_x = p_2.get_pos().x - trans_x
	#var p_2_y = p_2.get_pos().y - trans_y
	
	p_2.global_translate(Vector3(-trans_x, -trans_y, -trans_z))
	#p_2.set_pos(Vector3(p_2_x, p_2_y, p_1.get_pos().z))

extends Node

export var movement = Vector3(0,0,2)
export var spawn_interval = 3
var spawn_time = 0
var despawn_z = 4

var right_spawn_position
var left_spawn_position

var tree_scene = preload("res://Tree/Tree.tscn")

var right_tree_array = Array()
var left_tree_array = Array()

func _ready():
	spawn_time = spawn_interval
	right_spawn_position = get_node("TreeSpawnRight").get_global_transform().origin
	left_spawn_position = get_node("TreeSpawnLeft").get_global_transform().origin
	var number_of_original_trees = 6
	var left_position = left_spawn_position
	var right_position = right_spawn_position
	for i in range(number_of_original_trees):
		var left_tree = tree_scene.instance()
		left_tree.set_transform(Transform(left_tree.get_global_transform().basis, left_position))
		add_child(left_tree)
		left_tree_array.push_back(left_tree)
		var right_tree = tree_scene.instance()
		right_tree.set_transform(Transform(right_tree.get_global_transform().basis, right_position))
		add_child(right_tree)
		right_tree_array.push_back(right_tree)
		left_position += movement * spawn_interval
		right_position += movement * spawn_interval
	set_process(true)

func _process(delta):
	if spawn_time <= 0:
		var left_tree = tree_scene.instance()
		left_tree.set_transform(Transform(left_tree.get_global_transform().basis, left_spawn_position))
		add_child(left_tree)
		left_tree_array.push_back(left_tree)
		var right_tree = tree_scene.instance()
		right_tree.set_transform(Transform(right_tree.get_global_transform().basis, right_spawn_position))
		add_child(right_tree)
		right_tree_array.push_back(right_tree)
		spawn_time = spawn_interval
	
	var trees_to_remove = Array()
	
	for tree in left_tree_array:
		tree.global_translate(movement * delta)
		if tree.get_global_transform().origin.z > despawn_z:
			trees_to_remove.push_back(tree)
	
	for tree in trees_to_remove:
		left_tree_array.erase(tree)
		remove_child(tree)
	
	trees_to_remove.clear()
	
	for tree in right_tree_array:
		tree.global_translate(movement * delta)
		if tree.get_global_transform().origin.z > despawn_z:
			trees_to_remove.push_back(tree)
	
	for tree in trees_to_remove:
		right_tree_array.erase(tree)
		remove_child(tree)
	
	trees_to_remove.clear()
	
	spawn_time -= delta
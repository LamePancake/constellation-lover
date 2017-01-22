extends Node

var tail_offset = Vector3(0, 0, 0);

export var tail_node_path = NodePath()
var tail_start

func _ready():
	tail_start = get_node(tail_node_path)
	set_process(true)

func _process(delta):
	var tail_trans = tail_start.get_global_transform()
	tail_trans.origin = get_global_transform().origin + tail_offset;
	tail_start.set_global_transform(tail_trans)


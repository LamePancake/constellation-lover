var speed = 5;
var tail_offset = Vector3(0, -2.5, 0);

export var tail_node_path = NodePath()
var tail_start

func _ready():
	set_fixed_process(true)
	tail_start = get_node(tail_node_path)
	
func _fixed_process(delta):
	if (Input.is_action_pressed("MOVE_LEFT")):
		move(Vector3(-speed * delta, 0, 0))
	if (Input.is_action_pressed("MOVE_RIGHT")):
		move(Vector3(speed * delta, 0, 0))
	
	var tail_trans = tail_start.get_global_transform()
	tail_trans.origin = get_transform().origin + tail_offset;
	tail_start.set_global_transform(tail_trans)
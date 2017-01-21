var speed = 5;

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if (Input.is_action_pressed("MOVE_LEFT")):
		move(Vector3(-speed * delta, 0, 0))
	if (Input.is_action_pressed("MOVE_RIGHT")):
		move(Vector3(speed * delta, 0, 0))
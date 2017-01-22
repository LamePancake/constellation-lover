extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	# relaxation, lets run this multiple times so incase constraints where invalidated in an early pass.
	for i in range(4):
		get_tree().call_group(0, "link", "solve_constraints")

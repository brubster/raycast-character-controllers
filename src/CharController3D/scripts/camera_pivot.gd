extends Marker3D

@onready var char_controller: Node3D = get_node("../CharController")


func _physics_process(_delta):
	position = char_controller.position


func get_input_vector() -> Vector3:
	var direction: Vector3 = Vector3.ZERO
	# TODO
	return direction


extends Marker3D

@export var sensitivity: float = 0.25

@onready var char_controller: Node3D = get_node("../CharController")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta):
	position = char_controller.position


func _unhandled_input(event):
	if event is InputEventMouseMotion and \
			Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_x(event.relative.y * (0.05 * sensitivity))
		rotate_y(event.relative.x * (0.05 * sensitivity))
		rotation.z = 0
	
	if Input.is_action_just_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func get_input_vector() -> Vector3:
	var direction: Vector3 = Vector3.ZERO
	
	return direction


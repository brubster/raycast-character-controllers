extends SpringArm3D

@export var sensitivity: float = 1.0
@export var camera_distance: float = 5.0

@onready var char_controller: Node3D = get_node("../BodyPivot")
@onready var camera: Node3D = $CameraPivot/Camera


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_length(camera_distance)  # set SpringArm length


func _physics_process(_delta):
	position = char_controller.position


func _unhandled_input(event):
	if event is InputEventMouseMotion and \
			Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		rotation.x = clamp(rotation.x, deg_to_rad(-75), deg_to_rad(75))
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		rotation.z = 0
	if Input.is_action_just_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


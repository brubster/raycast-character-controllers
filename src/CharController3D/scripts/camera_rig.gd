extends Node3D


### 
### camera_rig.gd
### 


# Horizontal and Vertical Mouse Sensitivities
@export var horizontal_sensitivity: float = 0.25
@export var vertical_sensitivity: float = 0.2

# Zoom Settings
@export var max_zoom: float = 20.0
@export var min_zoom: float = 4.0
@export var zoom_step_x: float = 2.0
@export var zoom_step_y: float = 0.15

# Max and Min Pitch Degrees
@export var max_pitch_deg: float =  60.0
@export var min_pitch_deg: float = -60.0

# Other
@export var lerp_speed: float = 16.0
@export var target_path: NodePath


@onready var target = get_node(target_path)
@onready var spring_arm: SpringArm3D = $SpringArm
@onready var cur_zoom: float = min_zoom + 2.0
@onready var cur_height: float = 1.5

var height: float = cur_height


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	# Rotate rig around parent
	if event is InputEventMouseMotion:
		# Mouse X
		rotation.y -= (deg_to_rad(event.relative.x) * horizontal_sensitivity)
		fposmod(rotation.y, TAU)
		# Mouse Y
		rotation.x -= (deg_to_rad(event.relative.y) * vertical_sensitivity)
		rotation.x = clamp(rotation.x, deg_to_rad(min_pitch_deg), deg_to_rad(max_pitch_deg))
		# Zero out Z
		rotation.z = 0.0
	
	# Zoom in
	if event.is_action_pressed("scroll_up") and cur_zoom > min_zoom:
		cur_zoom -= zoom_step_x
		cur_height -= zoom_step_y
	# Zoom out
	if event.is_action_pressed("scroll_down") and cur_zoom < max_zoom:
		cur_zoom += zoom_step_x
		cur_height += zoom_step_y


func _physics_process(delta: float) -> void:
	# Zoom the camera smoothly
	spring_arm.spring_length = lerp(spring_arm.spring_length, cur_zoom, delta * lerp_speed)
	
	height = lerp(height, cur_height, delta * lerp_speed)
	global_position = (target.global_position + Vector3(0.0, height, 0.0))


extends CharacterBody3D


### 
### first_person_char_controller.gd
### 


# Horizontal and Vertical Mouse Sensitivities
@export var horizontal_sensitivity: float = 0.15
@export var vertical_sensitivity: float = 0.1

# Max and Min Pitch Degrees
@export var max_pitch_deg: float =  80.0
@export var min_pitch_deg: float = -80.0

# Movement variables
@export var speed: float = 14.0
@export var ground_accel: float = 0.2
@export var ground_decel: float = 0.4
@export var fall_accel: float = 65.0

@export var jump_force: float = 12.5

# 'Ride height' between the ground and BottomPivot
@export var ride_height: float = 0.5

# Spring values
@export var ride_spring_strength: float = 20.0
@export var ride_spring_damp: float = 0.75


@onready var camera_rig: Node3D = $CameraRig
@onready var pivot: Node3D = $BodyPivot
@onready var spring_raycast: RayCast3D = $BottomPivot/SpringRayCast
@onready var ground_raycast: RayCast3D = $BottomPivot/GroundRayCast


var can_move: bool = true
var target_velocity: Vector3 = Vector3.ZERO
var target_accel: float = ground_accel


func _ready() -> void:
	init_raycasts()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta) -> void:
	# Update target_velocity
	update_ground_velocity(delta)
	update_vertical_velocity(delta)
	
	# Update CharacterBody3D.velocity and move
	velocity = target_velocity
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	# Mouse input
	if event is InputEventMouseMotion:
		# Mouse X
		rotate_y(deg_to_rad(-event.relative.x) * horizontal_sensitivity)
		fposmod(rotation.y, TAU)
		# Mouse Y
		camera_rig.rotate_x(deg_to_rad(-event.relative.y) * vertical_sensitivity)
		camera_rig.rotation.x = clamp(camera_rig.rotation.x, \
				deg_to_rad(min_pitch_deg), deg_to_rad(max_pitch_deg))
		# Zero out Z
		rotation.z = 0.0


# Update the character's target GROUND velocity
func update_ground_velocity(_delta: float) -> void:
	var movement_input: Vector3 = get_movement_input_vector()
	if movement_input == Vector3.ZERO:
		target_accel = ground_decel
	else:
		target_accel = ground_accel
	# Convert input vector to in-game target direction
	var direction: Vector3 = \
		movement_input.rotated(Vector3.UP, rotation.y).normalized()
	
	# Update ground velocity
	target_velocity.x = lerp(velocity.x, direction.x * speed, target_accel)
	target_velocity.z = lerp(velocity.z, direction.z * speed, target_accel)


var time_since_jump_pressed: float = 0.0
# Update the character's target AIR velocity
# TODO: variable jump heights based on how long the button is held
func update_vertical_velocity(delta: float) -> void:
	var grounded: bool = is_grounded()
	if is_on_ceiling():
		target_velocity.y = 0.0
	
	if Input.is_action_just_pressed("jump") and grounded and can_move:
		time_since_jump_pressed = 0.05
		target_velocity.y = jump_force
	elif time_since_jump_pressed <= 0.0:
		apply_spring_force()
		target_velocity.y -= (fall_accel * delta) # Gravity
	
	if time_since_jump_pressed > 0.0:
		time_since_jump_pressed -= delta


func apply_spring_force() -> void:
	var ray_origin: Vector3 = spring_raycast.global_transform.origin
	var ray_hit: Vector3 = spring_raycast.get_collision_point()
	
	# If not 0, cur_height is the distance away from the desired ride height
	var cur_height: float = ray_origin.y - ray_hit.y - ride_height
	
	# Get the dot product of the character's movement velocity and 
	# the direction of the raycast. 
	var relative_velocity: float = velocity.dot(-spring_raycast.transform.basis.y)
	
	# Calculate the spring force needed to maintain ride height
	var spring_force: float = (cur_height * ride_spring_strength) - \
			(relative_velocity * ride_spring_damp)
	
	# Update air velocity
	if (spring_raycast.is_colliding()):
		target_velocity.y -= spring_force  # Spring


func get_movement_input_vector() -> Vector3:
	var input: Vector3 = Vector3.ZERO
	if not can_move:
		return input
	
	input.z -= Input.get_action_strength("move_forward")
	input.z += Input.get_action_strength("move_backward")
	input.x += Input.get_action_strength("move_right")
	input.x -= Input.get_action_strength("move_left")
	
	if input.length_squared() > 1:
		input = input.normalized()
	
	return input


func is_grounded() -> bool:
	return ground_raycast.is_colliding()


func _on_gui_can_move(val: bool) -> void:
	can_move = val


# Setup RayCasts
func init_raycasts() -> void:
	spring_raycast.target_position = Vector3(0.0, -(2 * ride_height), 0.0)
	spring_raycast.add_exception(self)
	ground_raycast.target_position = Vector3(0.0, -(ride_height + 0.1), 0.0)
	ground_raycast.add_exception(self)


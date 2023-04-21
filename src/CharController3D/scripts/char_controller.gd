extends CharacterBody3D


### 
### char_controller.gd
### 


@export var speed: float = 14.0
@export var fall_accel: float = 75.0

# 'Ride height' between the ground and BottomPivot
@export var ride_height: float = 0.5

# Spring values
@export var ride_spring_strength: float = 20.0
@export var ride_spring_damp: float = 0.75

@onready var camera_rig: Node3D = $CameraRig
@onready var pivot: Node3D = $BodyPivot
@onready var raycast: RayCast3D = $BottomPivot/RayCast

var input: Vector3 = Vector3.ZERO
var target_velocity: Vector3 = Vector3.ZERO


func _ready() -> void:
	# Setup RayCast
	raycast.target_position = Vector3(0.0, (-2 * ride_height), 0.0)
	raycast.add_exception(self)


func _physics_process(delta: float) -> void:
	update_ground_velocity(delta)
	update_vertical_velocity(delta)
	input = Vector3.ZERO
	
	# Update CharacterBody3D velocity and move
	velocity = target_velocity
	move_and_slide()


func _unhandled_input(_event: InputEvent) -> void:
	update_input_vector()


# Update the character's target GROUND velocity
func update_ground_velocity(_delta: float) -> void:
	# Convert input vector to in-game target direction
	var direction: Vector3 = \
			input.rotated(Vector3.UP, camera_rig.rotation.y).normalized()
	
	# Look toward target direction
	if direction != Vector3.ZERO:
		pivot.look_at(position + direction, Vector3.UP)
	
	# Update ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed


# Update the character's target AIR velocity
# TODO: variable jump heights based on how long the button was pressed
func update_vertical_velocity(delta: float) -> void:
	var ray_origin: Vector3 = raycast.global_transform.origin
	var ray_hit: Vector3 = raycast.get_collision_point()
	
	# If not 0, cur_height is the distance away from the desired ride height
	var cur_height: float = ray_origin.y - ray_hit.y - ride_height
	
	# Get the dot product of the character's movement velocity and 
	# the direction of the raycast. 
	var relative_velocity: float = velocity.dot(-raycast.transform.basis.y)
	
	# Calculate the spring force needed to maintain ride height
	var spring_force: float = (cur_height * ride_spring_strength) - \
			(relative_velocity * ride_spring_damp)
	
	# Update air velocity
	if (raycast.is_colliding()):
		target_velocity.y -= spring_force     # Spring
	target_velocity.y -= (fall_accel * delta) # Gravity


# Returns a normalized input vector, or Vector3.ZERO
func update_input_vector() -> Vector3:
	input.z -= Input.get_action_strength("move_forward")
	input.z += Input.get_action_strength("move_backward")
	input.x += Input.get_action_strength("move_right")
	input.x -= Input.get_action_strength("move_left")
	
	if input.length_squared() > 1:
		input = input.normalized()
	
	return input


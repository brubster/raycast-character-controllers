extends CharacterBody3D

### 
### char_controller.gd
### 

@export var speed: float = 14.0
@export var fall_acceleration: float = 75.0

@onready var camera_pivot: Node3D = get_node("../CameraPivot")

var target_velocity: Vector3 = Vector3.ZERO


func _physics_process(delta):
	# Get input and look in that direction
	var direction: Vector3 = get_input_vector()
	if direction != Vector3.ZERO:
		$Pivot.look_at(position + direction, Vector3.UP)
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Air Velocity / Gravity
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# Move Character
	velocity = target_velocity
	move_and_slide()


# Returns a normalized input vector, or Vector3.ZERO
func get_input_vector() -> Vector3:
	var input: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input.z -= 1
	if Input.is_action_pressed("move_backward"):
		input.z += 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	
	if input != Vector3.ZERO:
		#input = input.normalized()
		var r = camera_pivot.rotation
		print(r)
		print(input.normalized())
		input = (input * r.x).normalized()
	
	return input


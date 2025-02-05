class_name Character
extends CharacterBody3D


const SPEED := 15.0
const JUMP_VELOCITY := 4.5

@onready var figurine := %Figurine as Figurine

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		figurine.play_animation("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		figurine.play_animation("idle")
	
	if (direction.x > 0 and direction.z > 0) or (direction.x < 0 and direction.z < 0):
		figurine.rotation_degrees.y = 45
	elif (direction.x < 0 and direction.z > 0) or (direction.x > 0 and direction.z < 0):
		figurine.rotation_degrees.y = -45
	elif direction.x != 0:
		figurine.rotation_degrees.y = 90
	elif direction.z != 0:
		figurine.rotation_degrees.y = 0

	move_and_slide()

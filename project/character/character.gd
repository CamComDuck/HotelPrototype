class_name Character
extends CharacterBody3D

const SPEED := 20.0

var interacting_furniture : Furniture
var last_direction : Vector3

@onready var figurine := %Figurine as Figurine
@onready var carrying_marker := %CarryingMarker as Marker3D
@onready var shape_cast := %ShapeCast as ShapeCast3D


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	
	if shape_cast.is_colliding():
		if shape_cast.get_collider(0) is Furniture:
			interacting_furniture = shape_cast.get_collider(0)
	else:
		interacting_furniture = null
	
	if interacting_furniture != null:
		print(interacting_furniture.furniture_type.name)


func handle_movement(delta : float) -> void:
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
		
	if direction != Vector3.ZERO:
		last_direction = direction
	
	shape_cast.target_position.x = last_direction.x * 5
	shape_cast.target_position.z = last_direction.z * 5
	
	
	# If you have a better way to make him face the right direction,
	# PLEASE refactor this lol
	if direction.x > 0 and direction.z > 0:
		figurine.rotation_degrees.y = 45
	elif direction.x < 0 and direction.z < 0:
		figurine.rotation_degrees.y = -135
	elif direction.x < 0 and direction.z > 0:
		figurine.rotation_degrees.y = -45
	elif direction.x > 0 and direction.z < 0:
		figurine.rotation_degrees.y = 135
	elif direction.z == -1 and direction.x == 0:
		figurine.rotation_degrees.y = 180
	elif direction.z == 1 and direction.x == 0:
		figurine.rotation_degrees.y = 0
	elif direction.z == 0 and direction.x == -1:
		figurine.rotation_degrees.y = -90
	elif direction.z == 0 and direction.x == 1:
		figurine.rotation_degrees.y = 90

	move_and_slide()

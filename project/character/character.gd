class_name Character
extends CharacterBody3D

signal furniture_placed (furniture_placed : FurnitureType, position_placed : Vector3)

const SPEED := 20.0

var interacting_furniture : Furniture
var carrying_furniture : FurnitureType
var last_direction : Vector3
var allow_movement := true

@onready var figurine := %Figurine as Figurine
@onready var carrying_marker := %CarryingMarker as Marker3D
@onready var shape_cast := %ShapeCast as ShapeCast3D


func _physics_process(delta: float) -> void:
	if allow_movement:
		handle_movement(delta)
	
	if shape_cast.is_colliding():
		if shape_cast.get_collider(0) is Furniture:
			interacting_furniture = shape_cast.get_collider(0)
	else:
		interacting_furniture = null
	
	if Input.is_action_just_pressed("interact"):
		if interacting_furniture != null and carrying_furniture == null: 
			figurine.play_animation("pick-up")
			allow_movement = false
			await figurine.animation_finished
			
			# Pick up furniture
			allow_movement = true
			var hand_model := interacting_furniture.model.duplicate()
			hand_model.scale = Vector3(0.5, 0.5, 0.5)
			carrying_marker.add_child(hand_model)
			figurine.play_animation("holding-both")
			
			carrying_furniture = interacting_furniture.furniture_type
			interacting_furniture.queue_free()
			interacting_furniture = null
		
		elif carrying_marker.get_child_count() > 0:
			figurine.play_animation("pick-up")
			allow_movement = false
			await figurine.animation_finished
			
			# Put furniture down
			furniture_placed.emit(carrying_furniture, global_position)
			carrying_marker.get_child(0).queue_free()
			allow_movement = true
			carrying_furniture = null


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
		if carrying_marker.get_child_count() == 0:
			figurine.play_animation("walk")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if carrying_marker.get_child_count() == 0:
			figurine.play_animation("idle")
		
	if direction != Vector3.ZERO:
		last_direction = direction
	
	shape_cast.target_position.x = last_direction.x * 5
	shape_cast.target_position.z = last_direction.z * 5
	
	
	# If you have a better way to make him face the right direction,
	# PLEASE refactor this lol
	if last_direction.x > 0 and last_direction.z > 0:
		figurine.rotation_degrees.y = 45
	elif last_direction.x < 0 and last_direction.z < 0:
		figurine.rotation_degrees.y = -135
	elif last_direction.x < 0 and last_direction.z > 0:
		figurine.rotation_degrees.y = -45
	elif last_direction.x > 0 and last_direction.z < 0:
		figurine.rotation_degrees.y = 135
	elif last_direction.z == -1 and last_direction.x == 0:
		figurine.rotation_degrees.y = 180
	elif last_direction.z == 1 and last_direction.x == 0:
		figurine.rotation_degrees.y = 0
	elif last_direction.z == 0 and last_direction.x == -1:
		figurine.rotation_degrees.y = -90
	elif last_direction.z == 0 and last_direction.x == 1:
		figurine.rotation_degrees.y = 90

	move_and_slide()

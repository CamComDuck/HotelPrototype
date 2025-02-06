class_name Furniture
extends StaticBody3D

@export var furniture_type : FurnitureType

var model : Node3D

@onready var collision_shape := %CollisionShape as CollisionShape3D
@onready var price_label := %PriceLabel as Label3D


func _ready() -> void:
	model = load(furniture_type.model_path).instantiate() as Node3D
	add_child(model) 
	
	price_label.text = "$" + str(furniture_type.price)
	
	rotation_degrees.y = 180
	
	collision_shape.shape = BoxShape3D.new()
	collision_shape.shape.size = Vector3(GameInfo.tile_size * furniture_type.tiles_width, GameInfo.tile_size, GameInfo.tile_size * furniture_type.tiles_length)
	
	collision_shape.position.x = -1 * collision_shape.shape.size.x / 2.0
	collision_shape.position.z = collision_shape.shape.size.z / 2.0
	collision_shape.position.y = collision_shape.shape.size.y / 2.0
	
	price_label.position.x = -1 * collision_shape.shape.size.x / 2.0
	#price_label.position.z = (-1 * collision_shape.shape.size.z) + (collision_shape.shape.size.z / 2.0)
	price_label.position.z = -3
	price_label.position.y = collision_shape.shape.size.y / 2.0

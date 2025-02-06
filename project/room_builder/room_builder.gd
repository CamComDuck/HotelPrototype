class_name RoomBuilder
extends Node3D

var furniture := preload("res://furniture/furniture.tscn") as PackedScene


func _on_character_furniture_placed(furniture_placed: FurnitureType, position_placed: Vector3) -> void:
	var new_furniture := furniture.instantiate() as Furniture
	new_furniture.furniture_type = furniture_placed
	
	add_child(new_furniture)
	new_furniture.global_position.x = position_placed.x + 5
	new_furniture.global_position.z = position_placed.z + 5

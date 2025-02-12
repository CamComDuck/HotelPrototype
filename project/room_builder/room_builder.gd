class_name RoomBuilder
extends Node3D

var furniture := preload("res://furniture/furniture.tscn") as PackedScene

func _ready() -> void:
	# I know this is quick and dirty but it works for now.
		$Furniture.visible = false
		$Furniture7.visible = false
		$Furniture2.visible = false
		$Furniture3.visible = false
		$Furniture6.visible = false
		$Furniture4.visible = false
		$Furniture5.visible = false
		
func _on_character_furniture_placed(furniture_placed: FurnitureType, position_placed: Vector3) -> void:
	var new_furniture := furniture.instantiate() as Furniture
	new_furniture.furniture_type = furniture_placed
	
	add_child(new_furniture)
	new_furniture.global_position.x = position_placed.x + 5
	new_furniture.global_position.z = position_placed.z + 5


func _on_purchase_square_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		# I know this is quick and dirty but it works for now.
		$Furniture.visible = true
		$Furniture7.visible = true
		$Furniture2.visible = true
		$Furniture3.visible = true
		$Furniture6.visible = true
		$Furniture4.visible = true
		$Furniture5.visible = true

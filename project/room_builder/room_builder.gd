class_name RoomBuilder
extends Node3D


var money := 1000
var furniture := preload("res://furniture/furniture.tscn") as PackedScene

var placed_furnitures : Array[Furniture]

@onready var purchase_bathroom: Area3D = $PurchaseBathroom
@onready var bathroom_furnitures: Area3D = $BathroomFurnitures
@onready var bthroom_purchase_collider: CollisionShape3D = %BthroomPurchaseCollider
@onready var bthroom_furnitures_collider: CollisionShape3D = %BthroomFurnituresCollider



func _ready() -> void:
	print("Money Left: $" + str(money))
	bathroom_furnitures.hide()
	call_deferred("toggle_collision", true, bthroom_furnitures_collider)
	for child in bathroom_furnitures.get_children():
		if child is Furniture:
			child.toggle_collision(true)
		
		
func _on_character_furniture_placed(furniture_placed: Furniture, position_placed: Vector3) -> void:
	var new_furniture := furniture.instantiate() as Furniture
	new_furniture.furniture_type = furniture_placed.furniture_type
	
	add_child(new_furniture)
	new_furniture.global_position.x = position_placed.x + 5
	new_furniture.global_position.z = position_placed.z + 5
	
	placed_furnitures.append(new_furniture)


func _on_purchase_square_body_entered(body: Node3D) -> void:
	if body is Character:
		bathroom_furnitures.show()
		purchase_bathroom.hide()
		call_deferred("toggle_collision", false, bthroom_furnitures_collider)
		call_deferred("toggle_collision", true, bthroom_purchase_collider)
		for child in bathroom_furnitures.get_children():
			if child is Furniture:
				child.call_deferred("toggle_collision", false)


func _on_purchase_bathroom_body_exited(body: Node3D) -> void:
	if body is Character:
		bathroom_furnitures.hide()
		purchase_bathroom.show()
		call_deferred("toggle_collision", true, bthroom_furnitures_collider)
		call_deferred("toggle_collision", false, bthroom_purchase_collider)
		for child in bathroom_furnitures.get_children():
			if child is Furniture:
				child.call_deferred("toggle_collision", true)


func toggle_collision(is_disabled : bool, collider : CollisionShape3D) -> void:
	collider.disabled = is_disabled


func _on_purchase_furnitures_body_entered(body: Node3D) -> void:
	if body is Character:
		if not placed_furnitures.is_empty():
			print()
			print("Buying items:")
			print()
			for i in placed_furnitures:
				print("Buying " + i.furniture_type.name + " for $" + str(i.furniture_type.price))
				money -= i.furniture_type.price
				print("Money Left: $" + str(money))
				print()
			print("Now going to Hotel scene [Prototype Ends Here]")
			
		else:
			print("No furniture items to buy")
		


func _on_character_deleting_furniture(furniture_deleted: Furniture) -> void:
	placed_furnitures.erase(furniture_deleted)

class_name RoomBuilder
extends Node3D

var money := 1000
var furniture := preload("res://furniture/furniture.tscn") as PackedScene

var placed_furnitures : Array[Furniture]

@export var all_tiles : Array[Tile]

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
		

func check_furniture_placement_validity(furniture_placed: Furniture, tile_placed_on: Tile) -> bool:
	if furniture_placed.furniture_type.tiles_width > 1 or furniture_placed.furniture_type.tiles_length > 1:
		for i in all_tiles.size():
			if all_tiles[i] == tile_placed_on:
				
				if furniture_placed.furniture_type.tiles_width > 1 and i % 4 >= 3:
					return false
				elif furniture_placed.furniture_type.tiles_width > 1 and all_tiles[i + 1].furniture_on_tile != null:
					return false
				
				if i <= 3 and furniture_placed.furniture_type.tiles_length > 1:
					return false
				elif i <= 7 and furniture_placed.furniture_type.tiles_length > 2:
					return false
				elif i <= 11 and furniture_placed.furniture_type.tiles_length > 3:
					return false
				elif furniture_placed.furniture_type.tiles_length > 1 and all_tiles[i - 4].furniture_on_tile != null:
					return false
			
	return true


func _on_character_furniture_placed(furniture_placed: Furniture, tile_placed_on: Tile) -> void:
	var new_furniture := furniture.instantiate() as Furniture
	new_furniture.furniture_type = furniture_placed.furniture_type
	
	add_child(new_furniture)
	new_furniture.global_position = tile_placed_on.furniture_marker.global_position
	tile_placed_on.furniture_on_tile = new_furniture
	
	if new_furniture.furniture_type.tiles_width > 1 or new_furniture.furniture_type.tiles_length:
		for i in all_tiles.size():
			if all_tiles[i] == tile_placed_on:
				if new_furniture.furniture_type.tiles_width > 1:
					all_tiles[i + 1].furniture_on_tile = new_furniture
				if new_furniture.furniture_type.tiles_length > 1:
					all_tiles[i - 4].furniture_on_tile = new_furniture
	
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
			$PurchaseSound.play()
			
		else:
			print("No furniture items to buy")
		


func _on_character_deleting_furniture(furniture_deleted: Furniture) -> void:
	placed_furnitures.erase(furniture_deleted)
	for i in all_tiles.size():
		if all_tiles[i].furniture_on_tile == furniture_deleted:
			all_tiles[i].furniture_on_tile = null


func _on_background_music_finished() -> void:
	$BackgroundMusic.play()

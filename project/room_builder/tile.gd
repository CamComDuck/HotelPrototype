class_name Tile
extends Area3D

var furniture_on_tile : Furniture

@onready var indicator: Node3D = %indicator
@onready var furniture_marker: Marker3D = $FurnitureMarker

func _ready() -> void:
	indicator.hide()


func toggle_indicator(is_visible_now : bool) -> void:
	indicator.visible = is_visible_now


func _physics_process(delta: float) -> void:
	print(furniture_on_tile)

class_name Tile
extends Area3D

var has_furniture := false

@onready var indicator: Node3D = %indicator
@onready var furniture_marker: Marker3D = $FurnitureMarker

func _ready() -> void:
	indicator.hide()


func toggle_indicator(is_visible_now : bool) -> void:
	indicator.visible = is_visible_now

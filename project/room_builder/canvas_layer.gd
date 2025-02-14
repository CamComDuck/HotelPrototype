extends CanvasLayer
@onready var label: Label  = $Control/Label
@onready var player: CharacterBody3D = $"../Character"
@onready var scene: Node3D = $".."

func _process(delta: float) -> void:
	label.text = str(scene.money) + "/" + str(scene.money)

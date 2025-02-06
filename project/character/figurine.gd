class_name Figurine
extends Node3D

signal animation_finished

@onready var animation_player := %AnimationPlayer as AnimationPlayer

func play_animation (animation_name : String) -> void:
	animation_player.play(animation_name)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_finished.emit()

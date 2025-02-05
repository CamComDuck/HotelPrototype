class_name Figurine
extends Node3D

@onready var animation_player := %AnimationPlayer as AnimationPlayer

func play_animation (animation_name : String) -> void:
	animation_player.play(animation_name)

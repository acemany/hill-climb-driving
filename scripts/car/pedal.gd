class_name Pedal
extends TextureRect

const TEXTURE_OFF: Texture = preload("res://assets/pics/pedal_off.png")
const TEXTURE_ON: Texture = preload("res://assets/pics/pedal_on.png")


func activate() -> void:
	texture = TEXTURE_ON


func deactivate() -> void:
	texture = TEXTURE_OFF

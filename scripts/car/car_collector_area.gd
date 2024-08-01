class_name CarCollectorArea
extends Area2D

@export var car: Car
@export var shape_override: Shape2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	assert(car != null, "`car` value on CarCollectorArea cant be null")
	if shape_override != null:
		collision_shape_2d.shape = shape_override

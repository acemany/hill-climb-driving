class_name Gauge
extends TextureRect

const ROTATION_1: float = 265.0

var value: float:
	set(new_value):
		value = new_value

		if not is_node_ready():
			await ready

		meter.rotation_degrees = value * ROTATION_1


@onready var meter: TextureRect = $Meter

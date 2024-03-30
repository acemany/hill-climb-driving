class_name CarStats
extends RefCounted

const BASE_ACCELERATION: float = 80_000.0
const BASE_AIR_ROTATION_SPEED: float = 150_000.0
const BASE_DOWNWARD_PRESSURE: Vector2 = Vector2.DOWN * 1_250.0

var _raw_engine_acceleration: float = 1.0 : set = _set_raw_engine_acceleration
var _raw_air_rotation_speed: float = 1.0
var _raw_downward_pressure: float = 1.0

var engine_acceleration: float = BASE_ACCELERATION
var air_rotation_speed: float = BASE_AIR_ROTATION_SPEED
var fuel_capacity: float = 30.0
var downward_pressure: Vector2 = Vector2.ZERO
var bounciness: float = 16.0
var wheel_size: float = 1.0

func _set_raw_engine_acceleration(acceleration: float) -> void:
	_raw_engine_acceleration = acceleration
	engine_acceleration = acceleration * BASE_ACCELERATION

func _set_raw_air_rotation_speed(speed: float) -> void:
	_raw_air_rotation_speed = speed
	air_rotation_speed = speed * BASE_ACCELERATION

func _set_raw_downward_pressure(pressure: float) -> void:
	_raw_downward_pressure = pressure
	downward_pressure = pressure * BASE_DOWNWARD_PRESSURE
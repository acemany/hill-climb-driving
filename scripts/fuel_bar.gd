class_name FuelBar
extends ProgressBar

@export var show_next_fuel: bool = false : set = _set_show_next_fuel
@export var next_fuel_value: float = 0.0 : set = _set_next_fuel_value

@onready var label_next_fuel: Label = $LabelNextFuel
@onready var stylebox_fill: StyleBoxFlat = get_theme_stylebox("fill")


func _set_show_next_fuel(show_it: bool) -> void:
	show_next_fuel = show_it

	if not is_node_ready():
		await ready

	label_next_fuel.visible = show_it


func _set_next_fuel_value(val: float) -> void:
	next_fuel_value = val

	if not is_node_ready():
		await ready

	label_next_fuel.text = "%s m" % F.F(val)


func _on_value_changed(value_: float) -> void:
	var color: Vector2 = Vector2(1-value_, value_).normalized()
	stylebox_fill.bg_color = Color(color.x, color.y, 0)

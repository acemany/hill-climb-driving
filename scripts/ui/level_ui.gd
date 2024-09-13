class_name LevelUI
extends Control

const PAUSE_MODAL_SCENE: PackedScene = preload("res://scenes/ui/pause_modal.tscn")
const MILESTONE_NOT_READY_POS: Vector2 = Vector2(1400, 40)

@export var level: Level
@export var player: Car
# used for next fuel
@export var collectible_spawner: CollectibleSpawner

@export var never_show_next_fuel: bool = false

var highscore: float
var last_milestone: float

@onready var label_distance: Label = $LabelDistance
@onready var label_highscore: Label = $HBoxContainerHighscore/LabelHighscore
@onready var fuel_bar: FuelBar = $VBoxContainer/HBoxContainer/FuelBar
@onready var pedal_l: Pedal = $PedalL
@onready var pedal_r: Pedal = $PedalR
@onready var gauge_speed: Gauge = $GaugeSpeed
@onready var low_fuel_alarm: LowFuelAlarm = $LowFuelAlarm
@onready var level_map: Control = $LevelMap/Control
@onready var next_milestone: Control = $NextMilestone
@onready var milestone_lable: Label = $NextMilestone/Arrow


func _ready() -> void:
	highscore = get_highscore()

	player.gas_changed.connect(_on_player_gas_changed)
	player.brake_changed.connect(_on_player_brake_changed)
	player.low_fuel_reached.connect(_on_player_low_fuel_reached)
	player.refueled.connect(_on_player_refueled)
	player.fuel_depleted.connect(_on_player_fuel_depleted)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()

	var meters: float = player.highest_x / Level.PX_TO_M
	meters = maxf(0, meters)
	label_distance.text = "%s m" % F.F(meters)
	level_map.position.x = -fposmod(meters*2-120, 200)

	var next_mile: float
	if meters < last_milestone:
		next_mile = last_milestone
	else:
		next_mile = get_milestone(meters)
		player.last_milestone = last_milestone

	if next_mile - 440 > meters:
		next_milestone.position = MILESTONE_NOT_READY_POS
		milestone_lable.text = "\n%sm" % next_mile
		milestone_lable.add_theme_font_size_override("font_size", 48)
	else:
		next_milestone.position.x = 556 - 80 + (next_mile - meters) * 2
		next_milestone.position.y = 105
		milestone_lable.text = "▴"
		milestone_lable.add_theme_font_size_override("font_size", 36)


	var highscore_displayed: float = maxf(meters, highscore)
	label_highscore.text = "%s m" % F.F(highscore_displayed)

	var next_fuel_m: float = get_distance_to_next_fuel_in_meters()
	fuel_bar.value = player.fuel
	fuel_bar.show_next_fuel = next_fuel_m > 0 and next_fuel_m <= 100 and !never_show_next_fuel
	fuel_bar.next_fuel_value = next_fuel_m

	var meters_per_second: float = player.get_meters_per_second()
	gauge_speed.value = meters_per_second / 50.0


func get_distance_to_next_fuel_in_meters() -> float:
	var closest_instance: FuelCollectible = collectible_spawner.get_closest_fuel(player.position.x)
	var x: float

	if closest_instance != null:
		x = closest_instance.position.x
	else:
		x = collectible_spawner.get_next_fuel()

	return (x - player.position.x) / Level.PX_TO_M


func get_highscore() -> float:
	return Game.save.highscores.get_highscore(level.data)


func get_milestone(meters: float) -> float:
	return max(ceil(meters/200 + 0.5)*200, 500)

func pause_game() -> void:
	var modal: PauseModal = PAUSE_MODAL_SCENE.instantiate() as PauseModal
	add_child(modal)


func _on_player_gas_changed(new_state: bool) -> void:
	if new_state:
		pedal_r.activate()
	else:
		pedal_r.deactivate()


func _on_player_brake_changed(new_state: bool) -> void:
	if new_state:
		pedal_l.activate()
	else:
		pedal_l.deactivate()


func _on_player_low_fuel_reached() -> void:
	low_fuel_alarm.activate()


func _on_player_fuel_depleted() -> void:
	low_fuel_alarm.deactivate()


func _on_player_refueled(_was_out_of: bool) -> void:
	low_fuel_alarm.deactivate()


func _on_button_pause_pressed() -> void:
	pause_game()

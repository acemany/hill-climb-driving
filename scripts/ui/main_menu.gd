class_name MainMenu
extends Node2D

const GARAGE: PackedScene = preload("res://scenes/garage.tscn")
const SHOP: PackedScene = preload("res://scenes/shop.tscn")
const CREDITS: PackedScene = preload("res://scenes/ui/credits_modal.tscn")

var selected_level: int = 0:
	set(a):
		if a < 0 or a > 5:
			return

		var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(levels_container, "position",
							 Vector2(392 - a * 1352, levels_container.position.y), 1)

		selected_level = a

@onready var canvas_layer_ui: CanvasLayer = $CanvasLayerUI
@onready var label_version: Label = $CanvasLayerUI/LabelVersion
@onready var levels_container: CenterContainer = $CanvasLayerUI/CenterContainer


func _ready() -> void:
	label_version.text = "v%s" % ProjectSettings.get("application/config/version")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_on_button_quit_pressed()
	elif event.is_action_pressed("ui_left"):
		selected_level -= 1
	elif event.is_action_pressed("ui_right"):
		selected_level += 1

func _on_button_quit_pressed() -> void:
	Game.save_game()
	get_tree().quit()


func _on_button_garage_pressed() -> void:
	get_tree().change_scene_to_packed(GARAGE)


func _on_button_shop_pressed() -> void:
	get_tree().change_scene_to_packed(SHOP)


func _on_button_source_code_pressed() -> void:
	OS.shell_open("https://github.com/acemany/hill-climb-driving")


func _on_button_credits_pressed() -> void:
	var modal: CreditsModal = CREDITS.instantiate() as CreditsModal
	canvas_layer_ui.add_child(modal)


func _on_level_select_r_pressed() -> void:
	selected_level += 1


func _on_level_select_l_pressed() -> void:
	selected_level -= 1

extends Node2D

const SHOP: PackedScene = preload("res://shop/shop.tscn")

var garage: SaveGameGarage = Game.save.garage

@onready var label_equip_count: Label = %LabelEquipCount
@onready var ui_upgrade_item_details: UIUpgradeItemDetails = %UIUpgradeItemDetails


func _ready() -> void:
	Game.save.garage.item_selected.connect(_on_garage_item_selected)
	Game.save.garage.item_equipped_changed.connect(_on_garage_item_equipped_changed)
	Game.save.garage.max_equips_changed.connect(_on_garage_max_equips_changed)

	update_equipped_text()


func update_equipped_text() -> void:
	label_equip_count.text = "%d / %d" % [garage.get_equipped_count(), garage.get_max_equips()]


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_garage_item_selected(item: UpgradeItem) -> void:
	ui_upgrade_item_details.item = item


func _on_garage_item_equipped_changed(_item: UpgradeItem, _to: bool) -> void:
	update_equipped_text()


func _on_garage_max_equips_changed(_max_equips: bool) -> void:
	update_equipped_text()


func _on_button_get_more_pressed() -> void:
	get_tree().change_scene_to_packed(SHOP)

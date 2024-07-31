class_name UIUpgradeItemList
extends HFlowContainer

const ITEM_UPGRADE_SCENE: PackedScene = preload("res://scenes/ui/ui_upgrade_item.tscn")

var garage: SaveGameGarage


func _ready() -> void:
	garage = Game.save.garage

	for item: UpgradeItem in garage.inventory:
		add_item(item)


func add_item(item: UpgradeItem) -> void:
	var ui_item: UIUpgradeItem = ITEM_UPGRADE_SCENE.instantiate() as UIUpgradeItem
	ui_item.item = item
	add_child(ui_item)

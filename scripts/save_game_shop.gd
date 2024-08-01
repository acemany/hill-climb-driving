class_name SaveGameShop
extends Resource

signal item_offer_added(offer: ShopUpgradeItemOffer)
signal item_offer_removed(offer: ShopUpgradeItemOffer)

signal item_offer_pressed(offer: ShopUpgradeItemOffer)

const DEFINITIONS_POOL_1: Array[UpgradeItemDefinition] = [
	preload("res://resources/item_upg_defs/engine_acceleration.tres"),
	preload("res://resources/item_upg_defs/wheel_size.tres"),
	preload("res://resources/item_upg_defs/fuel_capacity.tres"),
	preload("res://resources/item_upg_defs/bounciness.tres"),
	preload("res://resources/item_upg_defs/downward_pressure.tres"),
	preload("res://resources/item_upg_defs/air_rotation_speed.tres"),
]

const DEFINITIONS_POOL_2: Array[UpgradeItemDefinition] = [
	preload("res://resources/item_upg_defs/binoculars_zoom.tres"),
	preload("res://resources/item_upg_defs/stability.tres"),
	preload("res://resources/item_upg_defs/wheel_distance.tres"),
	preload("res://resources/item_upg_defs/inward_wheels.tres"),
	preload("res://resources/item_upg_defs/center_of_mass_x.tres"),
	preload("res://resources/item_upg_defs/center_of_mass_x_minus.tres"),
	preload("res://resources/item_upg_defs/rightward_pressure.tres"),
]

@export var item_offers: Array[ShopUpgradeItemOffer] = []
@export var refresh_offer: ShopOffer = ShopOffer.new(100)


func initialize() -> void:
	generate_item_offers()


func roll_offers(pool: Array[UpgradeItemDefinition], amount: int) -> Array[UpgradeItemDefinition]:
	var items: Array[UpgradeItemDefinition] = pool.duplicate()
	items.shuffle()
	return items.slice(0, amount)


func generate_item_offers() -> void:
	for definition: UpgradeItemDefinition in roll_offers(DEFINITIONS_POOL_1, 3):
		add_item_offer(definition)
	for definition: UpgradeItemDefinition in roll_offers(DEFINITIONS_POOL_2, 2):
		add_item_offer(definition)


func get_price_multiplier() -> float:
	return clampf(1 + 0.3 * Game.save.garage.get_item_count(), 1.0, 4.0)


func add_item_offer(definition: UpgradeItemDefinition) -> void:
	var base_price: int = int(definition.base_gem_price * get_price_multiplier())
	var top_price: int = int(base_price * 1.1)
	var price: int = randi_range(base_price, top_price)
	var offer: ShopUpgradeItemOffer = ShopUpgradeItemOffer.new(price, definition)
	item_offers.append(offer)
	item_offer_added.emit(offer)


func remove_item_offer(offer: ShopUpgradeItemOffer) -> void:
	item_offers.erase(offer)
	offer.removed.emit()
	item_offer_removed.emit(offer)


func refresh() -> void:
	while item_offers.size() > 0:
		remove_item_offer(item_offers[0])
	assert(item_offers.size() == 0, "How, what and why")
	generate_item_offers()

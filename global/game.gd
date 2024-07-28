class_name Game
extends Node

const SAVE_PATH: String = "user://savegame.bin"

const DEFINITION_ENGINE: UpgradeItemDefinition = preload("res://item/upgrade/definitions/engine_acceleration.tres")

static var save: SaveGame = SaveGame.new()


static func save_blank(file: FileAccess) -> void:
	file.store_16(0)# coins
	file.store_16(0)# gems

	file.store_8(1)# garage items
	file.store_8(0)
	file.store_8(255)
	file.store_var(false, true)
	file.store_8(0)
	file.store_var(false, true)


	file.store_8(0)# shop items

	file.store_double(0)# Countryside
	file.store_double(0)# Desert
	file.store_double(0)# Highway
	file.store_double(0)# Mountain
	file.store_double(0)# Cliff
	file.store_double(0)# Nirvana

	file.store_32(0)# expirience


static func save_game() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var open_error: int = FileAccess.get_open_error()
	if open_error == OK:
		file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

		file.store_16(Game.save.coins)# coins
		file.store_16(Game.save.gems)# gems

		file.store_8(Game.save.garage.get_item_count())# garage items
		for item: UpgradeItem in Game.save.garage.inventory:
			file.store_8(item.level)
			file.store_8(item.tuned_level)
			file.store_var(item.is_equipped, true)
			# when i touch UpgradeItemDefinition here, UpgradeItem breaks... idk why, so i came to this
			@warning_ignore("unsafe_call_argument")
			file.store_8(item.get("definition").stat)
			@warning_ignore("unsafe_call_argument")
			file.store_var(item.get("definition").effect_formula.base < 0, true)

		file.store_8(len(Game.save.shop.item_offers.filter(func(a: ShopUpgradeItemOffer) -> bool:
				return a.price != 0 and a.get("definition").effect_formula != null)))# shop items
		for offer: ShopUpgradeItemOffer in Game.save.shop.item_offers:
			if offer.price == 0 or offer.get("definition").effect_formula == null:
				continue
			# i had to use the same kludge here
			@warning_ignore("unsafe_call_argument")
			file.store_8(offer.get("definition").stat)
			@warning_ignore("unsafe_call_argument")
			file.store_var(offer.get("definition").effect_formula.base < 0, true)

		file.store_double(Game.save.highscores.highscores[0])# Countryside
		file.store_double(Game.save.highscores.highscores[1])# Desert
		file.store_double(Game.save.highscores.highscores[2])# Highway
		file.store_double(Game.save.highscores.highscores[3])# Mountain
		file.store_double(Game.save.highscores.highscores[4])# Cliff
		file.store_double(Game.save.highscores.highscores[5])# Nirvana

		file.store_32(Game.save.experience.xp)# expirience

		file.close()
	else:
		push_error("%s!" % error_string(open_error))


static func try_load_game() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var open_error: int = FileAccess.get_open_error()
	if open_error == ERR_FILE_NOT_FOUND:
		file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

		save_blank(file)

		file.close()
		push_warning("No settings data(%s)! Will write blank file" % error_string(open_error))
	elif open_error != OK:
		push_error("%s!" % error_string(open_error))
	
	file = FileAccess.open(SAVE_PATH, FileAccess.READ)

	Game.save.coins = file.get_16()
	Game.save.gems = file.get_16()

	for i: int in range(file.get_8()):# garage items
		var temp: UpgradeItem = UpgradeItem.new()
		temp.level = file.get_8()
		temp.tuned_level = file.get_8()
		temp.is_equipped = file.get_var(true)

		var stat: int = file.get_8()
		var stat_negative: bool = file.get_var(true)
		if stat <= 5:
			temp.set("definition", save.shop.DEFINITIONS_POOL_1[stat])
		elif stat <= 7:
			temp.set("definition", save.shop.DEFINITIONS_POOL_2[stat-6])
		elif stat == 8:
			temp.set("definition", save.shop.DEFINITIONS_POOL_2[6])
		elif stat == 9:
			temp.set("definition", save.shop.DEFINITIONS_POOL_2[5 if stat_negative else 4])
		elif stat == 10:
			temp.set("definition", save.shop.DEFINITIONS_POOL_2[3 if stat_negative else 2])

		Game.save.garage.add_item(temp)

	for i: int in range(file.get_8()):# shop items
		var temp: UpgradeItemDefinition = UpgradeItemDefinition.new()
		var stat: int = file.get_8()
		var stat_negative: bool = file.get_var(true)
		if stat <= 5:
			temp = save.shop.DEFINITIONS_POOL_1[stat]
		elif stat <= 7:
			temp = save.shop.DEFINITIONS_POOL_2[stat-6]
		elif stat == 8:
			temp = save.shop.DEFINITIONS_POOL_2[6]
		elif stat == 9:
			temp = save.shop.DEFINITIONS_POOL_2[5 if stat_negative else 4]
		elif stat == 10:
			temp = save.shop.DEFINITIONS_POOL_2[3 if stat_negative else 2]

		Game.save.shop.add_item_offer(temp)

	Game.save.highscores.highscores = [file.get_double(),file.get_double(),file.get_double(),
										file.get_double(),file.get_double(),file.get_double()]

	Game.save.experience.xp = file.get_32()

	file.close()

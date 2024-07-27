class_name SaveGameHighscores
extends Resource

@export var highscores: Array[float] = [0, 0, 0, 0, 0, 0]


func try_submit(data: LevelData, meters: float) -> void:
	var id: int = data.id
	if id not in highscores:
		highscores[id] = meters
	else:
		var current_highscore: float = highscores[id] as float
		highscores[id] = maxf(current_highscore, meters)


func get_highscore(data: LevelData) -> float:
	var id: int = data.id
	if id not in highscores:
		return 0.0
	return highscores[id] as float

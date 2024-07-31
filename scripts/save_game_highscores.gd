class_name SaveGameHighscores
extends Resource

@export var highscores: Array[float] = [0, 0, 0, 0, 0, 0]


func try_submit(data: LevelData, meters: float) -> void:
	highscores[data.id] = maxf(highscores[data.id], meters)


func get_highscore(data: LevelData) -> float:
	return highscores[data.id]

class_name SaveGameMilestones
extends Resource

var milestones: Array[float] = [0, 0, 0, 0, 0, 0]


func try_submit(data: LevelData, meters: float) -> void:
	milestones[data.id] = maxf(milestones[data.id], meters)


func get_milestone(data: LevelData) -> float:
	return milestones[data.id]

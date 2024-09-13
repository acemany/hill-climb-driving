class_name LevelButton
extends TextureButton

@export var level_data: LevelData

@onready var label_title: Label = $LabelTitle
@onready var label_highscore: Label = $HBoxContainerHighscore/LabelHighscore
@onready var label_milestone: Label = $HBoxContainerMilestone/LabelMilestone


func _ready() -> void:
	assert(level_data != null, "can't make button linked to nothing")

	var highscore: float = Game.save.highscores.get_highscore(level_data)
	var milestone: float = Game.save.milestones.get_milestone(level_data)

	texture_normal = level_data.thumbnail
	label_title.text = level_data.title
	label_highscore.text = "%s m" % F.F(highscore)
	label_milestone.text = "%s m" % F.F(milestone)


func _on_pressed() -> void:
	get_tree().change_scene_to_file(level_data.scene_path)

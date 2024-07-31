class_name LevelData
extends Resource

@export_enum("Countryside", "Desert", "Highway", "Mountain", "Cliff", "Nirvana") var id: int
@export var title: String
@export_multiline var description: String
@export var thumbnail: Texture
@export_file("*.tscn") var scene_path: String

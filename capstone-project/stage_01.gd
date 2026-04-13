extends Node2D

@export var music: MusicManager.Music

func _ready() -> void:
	MusicPlayer.play(MusicManager.Music.STAGE)

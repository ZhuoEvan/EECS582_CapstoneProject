# ============================================= #
# Prologue Comment
#Name: Manages the music.
#Description: This .gd script provides music to be played.
#Authors: Jace
#creation date: 4/12/26
#Preconditon: Music manager script is created.
#Postcondition: Stages and main menu will have music.
# ============================================= #

# Declarations and references.
class_name MusicManager
extends Node
@onready var music_stream_player : AudioStreamPlayer = $MusicStreamPlayer
var autoplayed_music : AudioStream = null

# Maps all of the assests for easy access.
enum Music {MENU, STAGE, BOSS}
const MUSIC_MAP : Dictionary = {
	Music.MENU: preload("res://Assets/sound_effects/menu.mp3"),
	Music.STAGE: preload("res://Assets/sound_effects/stage.mp3"),
	Music.BOSS: preload("res://Assets/sound_effects/boss.mp3")
}

# Function starts when script runs. Makes sure music plays.
func _ready() -> void:
	if autoplayed_music != null:
		music_stream_player.stream = autoplayed_music
		music_stream_player.play()

# If the music can be played, it will play.
func play(music: Music) -> void:
	if music_stream_player.is_node_ready():
		music_stream_player.stream = MUSIC_MAP[music]
		music_stream_player.play()
	else:
		autoplayed_music = MUSIC_MAP[music]

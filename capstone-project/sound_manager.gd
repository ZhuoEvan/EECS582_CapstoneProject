# ============================================= #
# Prologue Comment
#Name: Manages the SFX.
#Description: This .gd script provides SFX to be played.
#Authors: Jace
#creation date: 4/12/26
#Preconditon: Sound manager script is created.
#Postcondition: Actions will have SFX.
# ============================================= #

# Declarations and references.
class_name SoundManager
extends Node

# Dictionary to hold SFX.
@onready var sounds := {
	Sound.HIT: $SFXHit,
	Sound.DEATH: $SFXDeath
}

# Function to play the SFX if it is there.
enum Sound { HIT, DEATH }
func play(sfx: Sound) -> void:
	if sounds.has(sfx):
		sounds[sfx].play()

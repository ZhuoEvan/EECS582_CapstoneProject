# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: main_menu.gd								#
# Description: Main Menu for the game					#
# Authors: Zhang, Evan									#
# Preconditon: 											#
# 	Game is open										#
# Postcondition: 										#
# 	Player being able to go various setting of the game#
# Creation date: 02/27/26								#
# ----------------------------------------------------- #
# Last modifed date:04/12/26							#
# Changes: 												#
#	updated main menu to be more formalized
# ===================================================== #
extends Control

@export var music: MusicManager.Music

#Ready Method
func _ready():
	MusicPlayer.play(MusicManager.Music.MENU)

#Start Game Button Method
func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://level_selection.tscn")

#Options Button Method
func _on_options_pressed() -> void:
	pass # Replace with function body.

#Credits Button Method
func _on_credits_pressed() -> void:
	pass # Replace with function body.

#Exit Button Method
func _on_exit_pressed() -> void:
	get_tree().quit()

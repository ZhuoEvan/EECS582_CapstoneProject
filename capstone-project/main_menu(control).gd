# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: main_menu.gd								#
# Description: Main Menu for the game					#
# Authors: Zhang										#
# Preconditon: 											#
# 	Game is open										#
# Postcondition: 										#
# 	Player being able to go various setting of the game#
# Creation date: 02/27/26								#
# ----------------------------------------------------- #
# Last modifed date:03/17/26							#
# Changes: 												#
#	implemented the level selection menu and level 1
# ===================================================== #
extends Control

@onready var level_select = $LevelSelect
@onready var main_menu = $ColorRect
@export var music: MusicManager.Music
#Ready Method
func _ready():
	MusicPlayer.play(MusicManager.Music.MENU)
	level_select.visible = false

#set level select panel to true so player can do level select
func _on_play_pressed():
	level_select.visible = true
	main_menu.visible = false

#set level select panel to false as player have back out of the level select menu
func _on_back_pressed():
	level_select.visible = false
	main_menu.visible = true

#non-functional, since it is not connected to anything
#func _on_SkillButton_pressed():
	#get_tree().change_scene_to_file("")

#non-functional, since it is not connected to anything
#func _on_SettingsButton_pressed():
	#get_tree().change_scene_to_file(")

#non-functional, since it is not connected to anything
#func _on_CreditsButton_pressed():
	#get_tree().change_scene_to_file(")

#level 1 button, currently connected to the main game
func _on_Level1_pressed() -> void:
	get_tree().change_scene_to_file("res://main_game.tscn")

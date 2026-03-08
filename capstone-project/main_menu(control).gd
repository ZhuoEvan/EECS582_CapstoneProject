# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: main_menu.gd								#
# Description: Main Menu for the game					#
# Authors: Zhang										#
# Preconditon: 											#
# 	Game is open										#
# Postcondition: 										#
# 	Player being able to go various setting of the game#
# Creation date: 03/27/26								#
# ----------------------------------------------------- #
# Last modifed date:03/27/26							#
# Changes: 												#
#	implemented a rough draft of the menu
# ===================================================== #
extends Control

@onready var level_select = $LevelSelect
#Ready Method
func _ready():
	level_select.visible = false

#set level select panel to true so player can do level select
#This function is currently not connected to LevelSelect, since there is no multiple level
func _on_PlayButton_pressed():
	level_select.visible = true

#set level select panel to false as player have back out of the level select menu
#This function is currently not connected to LevelSelect, since there is no multiple level
func _on_BackButton_pressed():
	level_select.visible = false

#currently comment out, but the basic idea is for each level created a button, cread a press function
#used get_tree() to change the scence to the corrsponding level
#func _on_Level1Button_pressed():

#non-functional, since it is not connected to anything
#func _on_SkillButton_pressed():
	#get_tree().change_scene_to_file("")

#non-functional, since it is not connected to anything
#func _on_SettingsButton_pressed():
	#get_tree().change_scene_to_file(")

#non-functional, since it is not connected to anything
#func _on_CreditsButton_pressed():
	#get_tree().change_scene_to_file(")

#currently play will go straight to the demo level, however, it should go to level select if multiple level is createdd
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://main_game.tscn")

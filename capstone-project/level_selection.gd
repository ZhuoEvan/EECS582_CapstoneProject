# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: level_selection.gd							#
# Description: Level Selection Screen					#
# Authors: Evan											#
# Preconditon: 											#
# 	User clicks the Start Game Button from Main Menu	#
# Postcondition: 										#
# 	User can select levels								#
# Creation date: 04/12/26								#
# ----------------------------------------------------- #
# Last modifed date:04/12/26							#
# Changes: 												#
#	created the file
# ===================================================== #
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#Level 1 Button Method
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://main_game.tscn")

#Level 2 Button Method
func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://main_game.tscn")

#Level 3 Button Method
func _on_level_3_pressed() -> void:
	pass # Replace with function body.

#Back Button Method
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu(control).tscn")

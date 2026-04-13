# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: pause.gd								#
# Description: Pause Menu for the game					#
# Authors: Zhang										#
# Preconditon: 											#
# 	Game is open and inside a level						#
# Postcondition: 										#
# 	Player being able to pause and do various setting of the game#
# Creation date: 03/17/26								#
# ----------------------------------------------------- #
# Last modifed date:03/20/26							#
# Changes: 												#
#	fix menu not showing issue and implemented quit
# ===================================================== #
extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	
#function for handling the input
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		#use a bool to check if the game is pause or not when clicking esc
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true
#the actual siginaling when the resume button is clicked, so the game will continue
func _on_pause_button_pressed() -> void:
	visible = false
	get_tree().paused = false 
#the actual siginaling when the wuit button is clicked, so the game will return to main menu
func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu(control).tscn")

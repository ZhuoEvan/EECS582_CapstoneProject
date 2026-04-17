# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: action_text_command.gd						#
# Description: Reads Input and Outputs Text				#
# Authors: Evan 										#
# Preconditon: Input									#
# Postcondition: Displays Text for a short duration		#
# Creation date: 04/16/26								#
# Last modified date: 04/16/26							#
# Changes:												#
#	Created File
# ===================================================== #
extends Control

#Timer Variable
var display_time : float = 2.0

#Label Variables
@onready var light_atk = $LightAttack
@onready var heavy_atk = $HeavyAttack


# =====[Section 02]==================================== #
# GLOBAL VARIABLES										#
# ===================================================== #


# =====[Section 03]==================================== #
# GODOT METHODS											#
# ===================================================== #

#Hide Action Command Method
func _hide_action_text() -> void:
	light_atk.hide()
	heavy_atk.hide()

#Show Action Command Method
func show_action_text(current_action) -> void:
	_hide_action_text() #Interrupt Action Text
	if current_action == "light_attack":
		light_atk.show()
		await get_tree().create_timer(display_time).timeout
		GameManager.current_action = null
	elif current_action == "heavy_attack":
		heavy_atk.show()
		await get_tree().create_timer(display_time).timeout
		GameManager.current_action = null
	
	_hide_action_text()

#Hide Action Text On-load Method
func _ready() -> void:
	_hide_action_text()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.current_action != null:
		show_action_text(GameManager.current_action)

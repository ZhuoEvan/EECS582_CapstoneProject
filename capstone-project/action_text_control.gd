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
var display_time : float = 0.5
var _active_timer: SceneTreeTimer = null # Track the current timer

#Label Variables
@onready var light_atk = $LightAttack
@onready var heavy_atk = $HeavyAttack
@onready var drill_punch = $DrillPunch


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
	drill_punch.hide()

#Show Action Command Method
func show_action_text(current_action : String) -> void:
	_hide_action_text() #Interrupt Action Text
	if current_action == "light_attack":
		light_atk.show()
		GameManager.current_action = ""
	elif current_action == "heavy_attack":
		heavy_atk.show()
		GameManager.current_action = ""
	elif current_action == "drill_punch":
		drill_punch.show()
		GameManager.current_action = ""

	var local_timer = get_tree().create_timer(display_time) #Create Timer
	_active_timer = local_timer
	
	await local_timer.timeout
	
	#Prevent New Timer
	if _active_timer == local_timer:
		_hide_action_text()
		

#Hide Action Text On-load Method
func _ready() -> void:
	_hide_action_text()
	GameManager.action_trigger.connect(show_action_text)

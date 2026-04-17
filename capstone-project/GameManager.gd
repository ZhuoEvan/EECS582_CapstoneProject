# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: GameManager.gd								#
# Description: Game Handler								#
# Authors: Evan											#
# Preconditon: None										#
# Postcondition: Handles Game Variables					#
# Creation date: 04/16/26								#
# ----------------------------------------------------- #
# Last modifed date:04/16/26							#
# Changes: 												#
#	file created
# ===================================================== #
extends Node


# =====[Section 02]==================================== #
# GLOBAL VARIABLES										#
# ===================================================== #

#Stage Variables
var selected_stage = null

#Action Command Variables
signal action_trigger(action_name : String)
var current_action: String = ""


# =====[Section 03]==================================== #
# GODOT METHODS											#
# ===================================================== #

#Track Action Method
func track_action(action_name: String):
	current_action = action_name #Declare action
	action_trigger.emit(action_name) #Send Signal

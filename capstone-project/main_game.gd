# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: main_game.gd								#
# Description: Camera Control							#
# Authors: Ian, Evan, Zhang								#
# Creation date: 03/01/26								#
# ----------------------------------------------------- #
# Last modifed date: 04/11/26							#
# Changes:												#
# >>> bug fix(Zhang)
# ===================================================== #

extends Node2D

#Camera Ready Variables
@onready var player := $ActorsContainer/Player
@onready var camera := $Camera

#Stage Ready Variables
@onready var stage1 = $Stage_01
@onready var stage2 = $Stage_02
@onready var stage3 = $Stage_03


# =====[Section 02]==================================== #
# Camera Methods										#
# ===================================================== #
#Camera Control Method
func _process(delta: float) -> void:
	#bug fix: game no longer crash when player died, 
	#instead the camera control will stop keep track of player(Zhang)
	if not is_instance_valid(player):
		return
	#Camera Follow Player Right
	if player.position.x > camera.position.x: 
		camera.position.x = player.position.x
	#Camera Follow Player Left
	elif player.position.x < camera.position.x and player.position.x >= 360:
		camera.position.x = player.position.x

##Camera Sync Method
#func sync_camera() -> void:
	#camera.position.x = player.position.x


# =====[Section 03]==================================== #
# Stage Selection										#
# ===================================================== #

#Hide Stages Method
func _hide_stages() -> void:
	stage1.hide() #Hide Stage 1
	stage1.process_mode = Node.PROCESS_MODE_DISABLED
	stage2.hide() #Hide Stage 2
	stage2.process_mode = Node.PROCESS_MODE_DISABLED
	stage3.hide() #Hide Stage 3
	stage3.process_mode = Node.PROCESS_MODE_DISABLED

#Load Stage Method
func _ready() -> void:
	_hide_stages() #Hide All Stages
	#Load Correct Stage
	if GameManager.selected_stage == "s1":
		stage1.show()
		stage1.process_mode = Node.PROCESS_MODE_INHERIT
	elif GameManager.selected_stage == "s2":
		stage2.show()
		stage2.process_mode = Node.PROCESS_MODE_INHERIT
	elif GameManager.selected_stage == "s3":
		stage3.show()
		stage3.process_mode = Node.PROCESS_MODE_INHERIT

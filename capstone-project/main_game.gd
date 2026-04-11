# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: main_game.gd								#
# Description: Camera Control							#
# Authors: Ian, Evan, Zhang									#
# Creation date: 03/01/26								#
# ----------------------------------------------------- #
# Last modifed date: 04/11/26							#
# Changes:												#
# >>> bug fix(Zhang)
# ===================================================== #

extends Node2D

@onready var player := $ActorsContainer/Player
@onready var camera := $Camera
@onready var stage := $Stage

# =====[Section 02]==================================== #
# Camera Methods										#
# ===================================================== #
#Camera Control Method
func _process(delta: float) -> void:
	#bug fix: game no longer crash when player died, 
	#instead the camera control will stop keep track of player(Zhang)
	if not is_instance_valid(player):
		return
	if player.position.x > camera.position.x: #Camera Follow Player Right
		camera.position.x = player.position.x
	#Camera Follow Player Left
	elif player.position.x < camera.position.x and player.position.x >= 360:
		camera.position.x = player.position.x

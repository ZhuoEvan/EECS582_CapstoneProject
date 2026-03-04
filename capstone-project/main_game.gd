# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: main_game.gd								#
# Description: Camera Control							#
# Authors: Ian, Evan									#
# Creation date: 03/01/26								#
# ----------------------------------------------------- #
# Last modifed date: 03/04/26							#
# Changes:												#
# >>> Added Prologue Comment
# ===================================================== #

extends Node2D

@onready var player := $ActorsContainer/Player
@onready var camera := $Camera

# =====[Section 02]==================================== #
# Camera Methods										#
# ===================================================== #
#Camera Control Method
func _process(delta: float) -> void:
	if player.position.x > camera.position.x:
		camera.position.x = player.position.x

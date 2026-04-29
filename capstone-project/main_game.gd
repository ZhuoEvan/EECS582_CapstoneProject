# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: main_game.gd								#
# Description: Camera Control							#
# Authors: Ian, Evan, Zhang								#
# Creation date: 03/01/26								#
# ----------------------------------------------------- #
# Last modifed date: 04/28/26							#
# Changes:												#
# >>> bug fix(Zhang)
# >>> camera boundary clamping added to prevent grey
#     space at stage edges
# ===================================================== #

extends Node2D

#Camera Ready Variables
@onready var player := $ActorsContainer/Player
@onready var camera := $Camera

#Stage Ready Variables
@onready var stage1 = $Stage_01
@onready var stage2 = $Stage_02
@onready var stage3 = $Stage_03

# Half the viewport width — used to clamp camera so the edge of the
# background is never scrolled past and grey space stays hidden.
const HALF_VIEW := 360

# Per-stage camera x limits (world coords of the stage's right edge).
# Adjust these if you resize a stage background.
var _cam_max_x := 1808  # default (Stage 1: right wall at ~2168 minus HALF_VIEW)


# =====[Section 02]==================================== #
# Camera Methods										#
# ===================================================== #
func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	#Camera Follow Player Right
	if player.position.x > camera.position.x:
		camera.position.x = player.position.x
	#Camera Follow Player Left
	elif player.position.x < camera.position.x and player.position.x >= 360:
		camera.position.x = player.position.x
	# Clamp so the camera never shows grey space past the stage right edge.
	camera.position.x = clamp(camera.position.x, HALF_VIEW, _cam_max_x)


# =====[Section 03]==================================== #
# Stage Selection										#
# ===================================================== #

func _hide_stages() -> void:
	stage1.hide()
	stage1.process_mode = Node.PROCESS_MODE_DISABLED
	stage2.hide()
	stage2.process_mode = Node.PROCESS_MODE_DISABLED
	stage3.hide()
	stage3.process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	_hide_stages()
	if GameManager.selected_stage == "s1":
		stage1.show()
		stage1.process_mode = Node.PROCESS_MODE_INHERIT
		# Stage 1: background ends near world x=2168; keep one viewport of room.
		_cam_max_x = 2168 - HALF_VIEW
	elif GameManager.selected_stage == "s2":
		stage2.show()
		stage2.process_mode = Node.PROCESS_MODE_INHERIT
		# Stage 2: 750 local px * scale 4 - 1 offset = world x 2999
		_cam_max_x = 2999 - HALF_VIEW
	elif GameManager.selected_stage == "s3":
		stage3.show()
		stage3.process_mode = Node.PROCESS_MODE_INHERIT
		# Stage 3: 601 local px * scale 4 = world x 2404
		_cam_max_x = 2404 - HALF_VIEW

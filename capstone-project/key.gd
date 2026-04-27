# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: key.gd										#
# Description: Key Pickup								#
# Authors: Evan											#
# Creation date: 04/26/26								#
# ===================================================== #

extends Area2D

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	get_tree().change_scene_to_file("res://level_selection.tscn")
	
	

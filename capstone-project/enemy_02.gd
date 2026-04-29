# =====[Section 01]==================================== #
# File Name: enemy_02.gd
# Description: Stronger enemy variant for levels 2-3.
#              Uses Enemy2 sprite. Higher HP, damage,
#              and speed than Enemy01.
# Authors: Zhang, Jace, Evan
# ===================================================== #

class_name Enemy02
extends Enemy01


# =====[Section 03]==================================== #
# INITIAL METHODS										#
# ===================================================== #
func _ready() -> void:
	super._ready()
	health = 35
	damage = 3
	speed = 65.0
	attack_cooldown = 0.8
	attack_duration = 0.35
	attack_range = 40.0

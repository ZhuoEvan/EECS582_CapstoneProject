# =====[Section 01]==================================== #
# File Name: cheese_pickup.gd
# Description: Cheese block health pickup. Heals the
#              player by 20 HP (capped at max_health)
#              when touched, then removes itself.
# Authors: Zhang, Jace, Evan
# Creation date: 04/28/26
# ===================================================== #

extends Area2D

@export var heal_amount: int = 20

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.health = min(body.health + heal_amount, body.max_health)
		body.health_changed.emit(body.health, body.max_health)
		queue_free()

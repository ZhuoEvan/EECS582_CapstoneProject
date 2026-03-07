# ============================================= #
# Prologue Comment
#Name: Receiving damage script
#Description: This .gd script provides damage receiving signals.
#Authors: Jace
#creation date: 3/7/26
#last modifed date: 3/7/26
#Preconditon: Componets for damage receiver created
#Postcondition: Signals to track receiving damage
# ============================================= #

class_name DamageReceiver
extends Area2D

signal damage_received(damage: int, direction: Vector2)

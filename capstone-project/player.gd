# ============================================= #
# Prologue Comment
#Name: Player specific script
#Description: This .gd script provides player only methods.
#Authors: Zhang, Jace
#creation date: 3/4/26
#last modifed date:3/4/26
#changes: Moved input handling to this child.
#Preconditon: character script is created.
#Postcondition: Player will have own methods.
# ============================================= #

class_name Player
extends Character

#Handling Input Method
func handle_input() -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	
	#Determine if it is Light ATK
	if can_attack() and Input.is_action_just_pressed("light_attack"):
		state = State.ATTACK

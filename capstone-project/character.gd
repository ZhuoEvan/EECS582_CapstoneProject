# ============================================= #
# Prologue Comment
#Name: Player movement/attack script
#Description: This .gd script provide the movement, attack and nessary information(health, damage, etc.) for the player characterr
#Authors: Zhang,
#creation date: 2/9/26
#last modifed date:2/23/26
#changes: added temp value for speed, put player in a group in order to be trackable by the enemy(Zhang)
#Preconditon: accetable button: W,A,S,D, right click, and left click
#Postcondition: Player will be able to move, and deal damage to enemy
# ============================================= #

extends CharacterBody2D

# ============================================= #
# STATISTIC VARIABLES							#
# ============================================= #
@export var health : int
@export var damage : int
@export var speed : float = 70.0

# ============================================= #
# State											#
# ============================================= #
enum State { IDLE, WALK, ATTACK }
var state: State = State.IDLE
var attack_type := ""


# ============================================= #
# Methods										#
# ============================================= #

#Process Method
func _process(_delta: float) -> void:
	handle_input()
	if state != State.ATTACK:
		handle_movement()
	handle_attacks()
	move_and_slide()

#Handling Input Method
func handle_input() -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	
	#Determine if it is Light ATK & Heavy ATK
	if can_attack() and Input.is_action_just_pressed("light_attack"):
		attack_type = "light_attack"
		state = State.ATTACK
	elif can_attack() and Input.is_action_just_pressed("heavy_attack"):
		attack_type = "heavy_attack"
		state = State.ATTACK

#Handling Movement Input Method
func handle_movement() -> void:
	if velocity.length() == 0:
		state = State.IDLE
	else:
		state = State.WALK

#Handling Attack Input Method
func handle_attacks() -> void:
	if state == State.ATTACK:
		print(attack_type)
		state = State.IDLE

#Attack Condition Helper Method
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK

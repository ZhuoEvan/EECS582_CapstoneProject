# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: enemy_01.gd								#
# Description: Handles movement, attack, and neccessary #
#			   information (health, damage, etc.) for 	#
#			   specifically enemy						#
# Authors: Zhang, Jace, Evan							#
# Preconditon: 											#
# 	Player Entity Exist									#
# Postcondition: 										#
# 	Track Player & Attempts to Damage Player			#
# Creation date: 02/23/26								#
# ----------------------------------------------------- #
# Last modifed date:03/04/26							#
# Changes: 												#
#	Organized Code (Evan)
# ===================================================== #

#Class Declaration & Class Connection
class_name Enemy1
extends Character


# =====[Section 02]==================================== #
# GLOBAL VARIABLES										#
# ===================================================== #
#Statistical Values
@export var attack_range : float = 3.0
@export var attack_cooldown : float = 1.0

#Reference Values
var player : Node2D #reference for player node
var can_attack_flag := true #flag to prevent stunlocking


# =====[Section 03]==================================== #
# INITIAL METHODS										#
# ===================================================== #
#Ready Method
func _ready() -> void:
	#Find the first node in the scene that belongs to the group "player"
	player = get_tree().get_first_node_in_group("player")
	#a safety check if player was not found
	if player == null:
		push_error("No player found in group 'player'")

#Process Method
func _physics_process(delta: float) -> void:
	#if player not found, dont do anything
	if player == null:
		return
	#calculate the distance between enemy and player
	var distance_to_player = global_position.distance_to(player.global_position)
	#If enemy is not currently attacking
	if state != State.ATTACK:
		#check if it within attack range, if not, move toward player
		if distance_to_player > attack_range:
			move_toward_player()
			#else change state and start to attack the player
		else:
			start_attack()
	
	#Handle Enemy Movement
	handle_animations()
	flip_sprites()
	move_and_slide()

#Passes parent method.
func handle_input() -> void:
	pass


# =====[Section 04]==================================== #
# MOVEMENT METHODS										#
# ===================================================== #
#Track Player Movement Method
func move_toward_player() -> void:
	#Calculate direction vector from enemy to player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed #Set velocity toward player
	state = State.WALK #change state to walk


# =====[Section 05]==================================== #
# ATTACK METHODS										#
# ===================================================== #
#Attack Method
func start_attack() -> void:
	#only attack if cooldown allows
	if can_attack_flag:
		state = State.ATTACK #change stat to attack
		velocity = Vector2.ZERO #stop movement
		perform_attack() #attack the player

#Damage Deal Method
func perform_attack() -> void:
	print("Enemy attacks player!")
	#Currently comment out since player has not have a take damage method in script, it should work if implemented
	#if player.has_method("take_damage"):
		#player.take_damage(damage)
	#set the attack flag to false
	can_attack_flag = false
	#get the colddown timer based on the enemy attack cool_down and wait
	await get_tree().create_timer(attack_cooldown).timeout
	#set it attack flag to true after timer expire
	can_attack_flag = true
	#return to idle state to loop again
	state = State.IDLE

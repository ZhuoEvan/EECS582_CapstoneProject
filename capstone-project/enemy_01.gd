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
# Last modifed date:04/11/26							#
# Changes: 												#
#	bug fix for receiving damage.(Zhang)
# ===================================================== #

#Class Declaration & Class Connection
class_name Enemy01
extends Character


# =====[Section 02]==================================== #
# GLOBAL VARIABLES										#
# ===================================================== #
#Statistical Values
@export var attack_range : float = 40.0
@export var attack_cooldown : float = 1.0
@export var attack_duration : float = 0.35
@export var fatigue_meter : float
@export var fatigued : bool

#Reference Values
var player : Node2D #reference for player node
var can_attack_flag := true #flag to prevent stunlocking


# =====[Section 03]==================================== #
# INITIAL METHODS										#
# ===================================================== #
#Ready Method
func _ready() -> void:
	super._ready()
	#Find the first node in the scene that belongs to the group "player"
	player = get_tree().get_first_node_in_group("player")
	#a safety check if player was not found
	if player == null:
		push_error("No player found in group 'player'")
	#Assign Stats
	health = 20
	damage = 1
	
#Process Method
func _physics_process(delta: float) -> void:
	#if player not found, dont do anything
	if player == null:
		return
	#calculate the distance between enemy and player
	var distance_to_player = global_position.distance_to(player.global_position)
	#If enemy is not currently attacking
	if (state != State.ATTACK) && on_screen(distance_to_player) && !(fatigued):
		#check if it within attack range, if not, move toward player
		if distance_to_player > attack_range:
			move_toward_player()
			#else change state and start to attack the player
		else:
			enemy_attack()
	super._physics_process(delta)

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
	velocity = direction * (speed * 0.75) #Set velocity toward player
	fatigue_meter += 0.001
	state = State.WALK #change state to walk

#Idle Movement Method
func enemy_idle() -> void:
	#Set State to IDLE
	state = State.IDLE
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack_flag = true 
	
#Enemy On-screen Method
func on_screen(DIST) -> bool:
	#Enemy moves only in proximity to the Player
	if DIST <= 360: return true
	else: return false

#Fatigue Method
func max_fatigue() -> void:
	if fatigue_meter >= 10 && !(fatigued):
		#Force no movement after max fatigue
		fatigued = true
		state = State.IDLE
		velocity = Vector2.ZERO
		await get_tree().create_timer(1).timeout #TBD: change value in future
		#Reset Fatigue Meter
		fatigued = false
		fatigue_meter = 0


# =====[Section 05]==================================== #
# ATTACK METHODS										#
# ===================================================== #
#Attack Method
func enemy_attack() -> void:
	if can_attack_flag:
		state = State.ATTACK
		velocity = Vector2.ZERO
		can_attack_flag = false
		await get_tree().create_timer(attack_duration).timeout
		print("Enemy attacks player!")
		
		# Emit damage to any overlapping damage receivers(Zhang)
		for area in damage_emitter.get_overlapping_areas():
			if area is DamageReceiver:
				on_emit_damage(area)
		
		fatigue_meter += 1
		enemy_idle()
	
func start_attack() -> void:
	state = State.ATTACK #change state to attack
	can_attack_flag = false
	await get_tree().create_timer(attack_duration).timeout
	state = State.IDLE
	velocity = Vector2.ZERO #stop movement
	perform_attack() #attack the player

#Damage Deal Method
func perform_attack() -> void:
	print("Enemy attacks player!")
	
	#Currently comment out since player has not have a take damage method in script, it should work if implemented
	# if player.has_method("on_receive_damage"):
		# player.on_receive_damage(damage)
	#set the attack flag to false

	#return to idle state to loop again
	#state = State.IDLE
	#get the colddown timer based on the enemy attack cool_down and wait
	await get_tree().create_timer(attack_cooldown).timeout
	#set it attack flag to true after timer expire
	can_attack_flag = true

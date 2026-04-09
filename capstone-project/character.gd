# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: character.gd								#
# Description: Handles movement, attack, and neccessary #
#			   information (health, damage, etc.) for 	#
#			   characters								#
# Authors: Zhang, Jace, Evan							#
# Preconditon: 											#
# 	Acceptable button: W,A,S,D, Left & Right Click		#
# Postcondition: 										#
# 	Player will be able to move, and deal damage to 	#
#	enemy												#
# Creation date: 02/09/26								#
# ----------------------------------------------------- #
# Last modifed date:03/24/26							#
# Changes: 												#
#	Death Implementation
# ===================================================== #

#Class Declaration & Class Connection
class_name Character
extends CharacterBody2D
signal health_changed(current_health: int, max_health: int)
signal died

# =====[Section 02]==================================== #
# GLOBAL VARIABLES										#
# ===================================================== #
#Statistical Values
@export var health : int
@export var damage : int
@export var speed : float
@export var max_health : int = 100

#Child Variables
@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $Sprite2D
@onready var damage_emitter := $DamageEmitter
@onready var damage_receiver : DamageReceiver = $DamageReceiver

#Character State
enum State { IDLE, WALK, ATTACK, LIGHT_ATTACK, HEAVY_ATTACK, HURT, DEATH}
var state: State = State.IDLE
var is_dead_handled: bool = false
# =====[Section 03]==================================== #
# INITIAL METHODS										#
# ===================================================== #

#Gets the damage components connected
func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_receiver.damage_received.connect(on_receive_damage.bind())

#Process Method
func _physics_process(_delta: float) -> void:
	handle_input()
	if can_move():
		handle_movement()
	handle_animations()
	flip_sprites()
	move_and_slide()
	handle_death(_delta)
	
#Handling Input Method
func handle_input() -> void:
	pass


# =====[Section 04]==================================== #
# MOVEMENT METHODS										#
# ===================================================== #
#Handling Movement Input Method
func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK

#Move Condition Helper Method
# Checks if character can move.
func can_move() -> bool:
	return state == State.IDLE or state == State.WALK

#Handling Death Method
func handle_death(delta: float) -> void:
	if is_dead_handled:
		return
	if check_death():
		is_dead_handled = true
		state = State.DEATH
		died.emit()
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
#Death Handling Helper Method
func check_death() -> bool:
	if health <= 0: #Check Health
		return true
	else:
		return false


# =====[Section 05]==================================== #
# ATTACK METHODS										#
# ===================================================== #
#Attack Condition Helper Method
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK

#Revert to Idle State Method
# Changes state back to IDLE.
func on_action_complete() -> void:
	state = State.IDLE
	#use to reset Player damage multiplier just in case player perform a combo
	if self is Player:
		(self as Player).current_damage_multiplier = 1.0

#Method for handling receiving damage
func on_receive_damage(damage: int, direction: Vector2) -> void:
	health = health - damage #Apply Damage to Health
	health = clamp(health, 0, max_health)
	if health > 0:
		state = State.HURT #State Change to HURT
	health_changed.emit(health, max_health)
	
#Method for handling emitting damage
func on_emit_damage(damage_receiver: DamageReceiver) -> void:
	var direction := Vector2.LEFT if damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
	var final_damage = damage
	if state == State.HEAVY_ATTACK:
		#temp value for heavy attack
		final_damage = 1.5* damage
		#check if it player performing the attack
	if self is Player:
		#if it is player, then final damage will be muitliper by current damage multiplier
		final_damage *= (self as Player).current_damage_multiplier
	damage_receiver.damage_received.emit(final_damage, direction)
	print(damage_receiver)
	print(final_damage)

# =====[Section 06]==================================== #
# ANIMATION METHODS										#
# ===================================================== #
# Animation Selector Helper Method
func handle_animations() -> void:
	if state == State.IDLE:
		animation_player.play("idle")
	elif state == State.WALK:
		animation_player.play("walk")
	elif state == State.LIGHT_ATTACK:
		animation_player.play("light_attack")
	#need adding the heavy attack animation in animation player, since it currently bugging the game(Zhang)
	#elif state == State.HEAVY_ATTACK:
		#animation_player.play("heavy_attack")
	elif state == State.ATTACK:
		animation_player.play("light_attack")
	elif state == State.HURT:
		animation_player.play("hurt")
	elif state == State.DEATH:
		animation_player.play("death")

#Sprite Flip Method
#Flips the sprites to correct facing direction.
func flip_sprites() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1

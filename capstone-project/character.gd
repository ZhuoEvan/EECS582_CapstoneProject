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
# Last modifed date:03/04/26							#
# Changes: 												#
#	Organized Code (Evan)
# ===================================================== #

#Class Declaration & Class Connection
class_name Character
extends CharacterBody2D


# =====[Section 02]==================================== #
# GLOBAL VARIABLES										#
# ===================================================== #
#Statistical Values
@export var health : int
@export var damage : int
@export var speed : float

#Child Variables
@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $Sprite2D
@onready var damage_emitter := $DamageEmitter
@onready var damage_receiver : DamageReceiver = $DamageReceiver

#Character State
enum State { IDLE, WALK, ATTACK, HURT}
var state: State = State.IDLE

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
	if state != State.ATTACK:
		handle_movement()
	handle_animations()
	flip_sprites()
	move_and_slide()

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

#Method for handling receiving damage
func on_receive_damage(damage: int, direction: Vector2) -> void:
	state = State.HURT

#Method for handling emitting damage
func on_emit_damage(damage_receiver: DamageReceiver) -> void:
	var direction := Vector2.LEFT if damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
	damage_receiver.damage_received.emit(damage, direction)
	print(damage_receiver)

# =====[Section 06]==================================== #
# ANIMATION METHODS										#
# ===================================================== #
# Animation Selector Helper Method
func handle_animations() -> void:
	if state == State.IDLE:
		animation_player.play("idle")
	elif state == State.WALK:
		animation_player.play("walk")
	elif state == State.ATTACK:
		animation_player.play("light_attack")
	elif state == State.HURT:
		animation_player.play("hurt")

#Sprite Flip Method
#Flips the sprites to correct facing direction.
func flip_sprites() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1

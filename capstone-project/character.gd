# ============================================= #
# Prologue Comment
#Name: Character movement/attack script
#Description: This .gd script provide the movement, attack and nessary information(health, damage, etc.) for the charactersr
#Authors: Zhang, Jace
#creation date: 2/9/26
#last modifed date:3/4/26
#changes: Animations and smoothed movement (Jace)
#Preconditon: accetable button: W,A,S,D, right click, and left click
#Postcondition: Player will be able to move, and deal damage to enemy
# ============================================= #

class_name Character
extends CharacterBody2D

# ============================================= #
# STATISTIC VARIABLES							#
# ============================================= #
@export var health : int
@export var damage : int
@export var speed : float

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $Sprite2D

# ============================================= #
# State											#
# ============================================= #
enum State { IDLE, WALK, ATTACK }
var state: State = State.IDLE

# ============================================= #
# Methods										#
# ============================================= #

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

#Handling Movement Input Method
func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK
	else:
		velocity = Vector2.ZERO

#Attack Condition Helper Method
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK
	
# Animation Selector Helper Method
func handle_animations() -> void:
	if state == State.IDLE:
		animation_player.play("idle")
	elif state == State.WALK:
		animation_player.play("walk")
	elif state == State.ATTACK:
		animation_player.play("light_attack")

#Flips the sprites to correct facing direction.
func flip_sprites() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
	elif velocity.x < 0:
		character_sprite.flip_h = true

# Checks if character can move.
func can_move() -> bool:
	return state == State.IDLE or state == State.WALK

# Changes state back to IDLE.
func on_action_complete() -> void:
	state = State.IDLE

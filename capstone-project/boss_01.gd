# =====[Section 01]==================================== #
# (Prologue Comment)									#
# File Name: boss_01.gd									#
# Description: Handles movement, attack, and necessary  #
#			   information for the boss character.      #
#			   Boss has idle, walk, hurt (scream), and  #
#			   stomp attack animations.                 #
# Authors: Evan, Zhang									#
# Preconditon: Player Entity Exist						#
# Postcondition: Boss tracks player, stomps with high   #
#   damage, but does NOT stomp every opportunity.       #
# Creation date: 03/31/26								#
# Last modified date: 04/13/26							#
# Changes:												#
#	Rebuilt: proper collision layers, stomp mechanic,   #
#	animations (idle/walk/hurt/stomp), and random       #
#	attack chance so boss doesn't always stomp.         #
# ===================================================== #

class_name Boss01
extends Character


# =====[Section 02]==================================== #
# GLOBAL VARIABLES										#
# ===================================================== #
@export var attack_range : float = 80.0
@export var attack_cooldown : float = 3.0  # Stomp has a long cooldown
@export var attack_duration : float = 0.7  # Total stomp animation length (must match tscn)
@export var fatigue_meter : float = 0.0
@export var fatigued : bool = false

# Stomp chance: boss only stomps ~40% of the time it's in range
@export var stomp_chance : float = 0.4

var player : Node2D
var can_attack_flag := true
var stomp_cooldown_timer := 0.0  # Tracks time since last stomp


# =====[Section 03]==================================== #
# INITIAL METHODS										#
# ===================================================== #
func _ready() -> void:
	super._ready()
	# Boss-specific collision so player attacks can register
	collision_layer = 4
	collision_mask = 8
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("Boss: No player found in group 'player'")
	# Stats are set via exported values in boss_01.tscn
	# (health=100, damage=20, speed=65) but ensure they are set
	if health <= 0:
		health = 100
	if damage <= 0:
		damage = 20

func _physics_process(delta: float) -> void:
	if player == null:
		return

	# Count down the stomp cooldown each frame
	stomp_cooldown_timer = max(0.0, stomp_cooldown_timer - delta)

	var distance_to_player = global_position.distance_to(player.global_position)

	# Only act when not already attacking, not hurt, not dead, and player is nearby
	if state != State.LIGHT_ATTACK \
	   and state != State.HURT \
	   and state != State.DEATH \
	   and on_screen(distance_to_player) \
	   and !fatigued:
		if distance_to_player > attack_range:
			move_toward_player()
		elif stomp_cooldown_timer <= 0 and can_attack_flag:
			# Roll the dice: boss only stomps stomp_chance of the time
			if randf() < stomp_chance:
				enemy_attack()
			else:
				# Skip this opportunity — wait a short moment before checking again
				stomp_cooldown_timer = 1.0

	super._physics_process(delta)

func handle_input() -> void:
	pass

# Boss sprites face LEFT by default, which is the opposite of the player convention.
# Invert flip_h so the boss always faces toward its movement direction correctly.
func flip_sprites() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = true   # moving right → mirror the left-facing sprite
		damage_emitter.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = false  # moving left → natural left-facing direction
		damage_emitter.scale.x = -1


# =====[Section 04]==================================== #
# MOVEMENT METHODS										#
# ===================================================== #
func move_toward_player() -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * (speed * 0.75)
	fatigue_meter += 0.001
	state = State.WALK

func enemy_idle() -> void:
	state = State.IDLE
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack_flag = true

func on_screen(dist: float) -> bool:
	return dist <= 400

func max_fatigue() -> void:
	if fatigue_meter >= 10000 and !fatigued:
		fatigued = true
		state = State.IDLE
		velocity = Vector2.ZERO
		await get_tree().create_timer(2.0).timeout
		fatigued = false
		fatigue_meter = 0


# =====[Section 05]==================================== #
# ATTACK METHODS (STOMP)								#
# ===================================================== #
func enemy_attack() -> void:
	if can_attack_flag:
		# Use LIGHT_ATTACK state so the "light_attack" (stomp) animation plays
		state = State.LIGHT_ATTACK
		velocity = Vector2.ZERO
		can_attack_flag = false

		# Wait for the stomp animation's damage window (t=0.3 in the animation)
		await get_tree().create_timer(0.3).timeout

		# Deal damage to any player in range
		for area in damage_emitter.get_overlapping_areas():
			if area is DamageReceiver:
				on_emit_damage(area)

		fatigue_meter += 1
		# Reset stomp cooldown so the boss can't immediately stomp again
		stomp_cooldown_timer = attack_cooldown
		enemy_idle()

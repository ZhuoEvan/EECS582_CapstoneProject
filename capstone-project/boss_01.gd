# =====[Section 01]==================================== #
# File Name: boss_01.gd
# Description: Handles movement, attack, and necessary
#              information for the boss character.
#              Boss has idle, walk, hurt (scream), stomp
#              attack, and (on levels 2-3) a slam attack
#              that deals 2x damage.
# Authors: Evan, Zhang
# Precondition: Player Entity Exists
# Postcondition: Boss tracks player and alternates between
#   stomp (light_attack) and slam (heavy_attack) based on
#   level. Slam deals significantly more damage.
# Creation date: 03/31/26
# Last modified date: 04/29/26
# Changes:
#   Added slam attack (heavy_attack) with bossslam.png.
#   Added has_slam export so only lv2/lv3 bosses slam.
#   Added slam_damage_multiplier (default 2.0x stomp dmg).
#   Reworked enemy_attack() into stomp_attack() /
#   slam_attack() chosen randomly when has_slam = true.
# ===================================================== #

class_name Boss01
extends Character


# =====[Section 02]==================================== #
# GLOBAL VARIABLES                                      #
# ===================================================== #
@export var attack_range        : float = 80.0
@export var attack_cooldown     : float = 3.0
@export var attack_duration     : float = 0.7
@export var fatigue_meter       : float = 0.0
@export var fatigued            : bool  = false

# Probability that the boss actually attacks when in range.
@export var stomp_chance        : float = 0.4

# Set to true on level 2 and 3 boss instances to unlock the slam.
@export var has_slam            : bool  = false

# Slam deals this multiple of base damage (e.g. 2.0 = double stomp damage).
@export var slam_damage_multiplier : float = 2.0

var player              : Node2D
var can_attack_flag     := true
var stomp_cooldown_timer := 0.0


# =====[Section 03]==================================== #
# INITIAL METHODS                                       #
# ===================================================== #
func _ready() -> void:
	super._ready()
	collision_layer = 4
	collision_mask  = 8
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("Boss: No player found in group 'player'")
	if health <= 0:
		health = 100
	if damage <= 0:
		damage = 20

func _physics_process(delta: float) -> void:
	if player == null:
		return

	stomp_cooldown_timer = max(0.0, stomp_cooldown_timer - delta)

	var dist = global_position.distance_to(player.global_position)

	# Do nothing while already attacking, hurt, dead, or out of range.
	if state != State.LIGHT_ATTACK  \
	   and state != State.HEAVY_ATTACK \
	   and state != State.HURT     \
	   and state != State.DEATH    \
	   and on_screen(dist)         \
	   and !fatigued:
		if dist > attack_range:
			move_toward_player()
		elif stomp_cooldown_timer <= 0 and can_attack_flag:
			if randf() < stomp_chance:
				enemy_attack()      # picks stomp OR slam
			else:
				stomp_cooldown_timer = 1.0   # brief pause before re-evaluating

	super._physics_process(delta)

func handle_input() -> void:
	pass

# Boss sprites face LEFT by default — invert flip_h so it faces movement.
func flip_sprites() -> void:
	if velocity.x > 0:
		character_sprite.flip_h  = true
		damage_emitter.scale.x   = 1
	elif velocity.x < 0:
		character_sprite.flip_h  = false
		damage_emitter.scale.x   = -1


# =====[Section 04]==================================== #
# MOVEMENT METHODS                                      #
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
		state    = State.IDLE
		velocity = Vector2.ZERO
		await get_tree().create_timer(2.0).timeout
		fatigued      = false
		fatigue_meter = 0


# =====[Section 05]==================================== #
# ATTACK METHODS                                        #
# ===================================================== #

# Router: picks slam 50% of the time when has_slam is enabled.
func enemy_attack() -> void:
	if has_slam and randf() < 0.5:
		slam_attack()
	else:
		stomp_attack()

# ── STOMP (existing light attack, base damage) ───────
func stomp_attack() -> void:
	if not can_attack_flag:
		return
	state            = State.LIGHT_ATTACK
	velocity         = Vector2.ZERO
	can_attack_flag  = false

	# Wait for the stomp animation's damage window (matches DamageEmitter track at t=0.25)
	await get_tree().create_timer(0.3).timeout

	for area in damage_emitter.get_overlapping_areas():
		if area is DamageReceiver:
			on_emit_damage(area)

	fatigue_meter        += 1
	stomp_cooldown_timer  = attack_cooldown
	enemy_idle()

# ── SLAM (heavy attack, 2× damage, bossslam.png) ─────
func slam_attack() -> void:
	if not can_attack_flag:
		return
	state            = State.HEAVY_ATTACK
	velocity         = Vector2.ZERO
	can_attack_flag  = false

	# Temporarily boost damage for the slam hit.
	var base_damage  = damage
	damage           = int(base_damage * slam_damage_multiplier)

	# Wait for the slam animation's damage window (DamageEmitter track on at t=0.35)
	await get_tree().create_timer(0.38).timeout

	for area in damage_emitter.get_overlapping_areas():
		if area is DamageReceiver:
			on_emit_damage(area)

	# Restore base damage so stomp stays at normal value.
	damage               = base_damage
	fatigue_meter        += 1
	stomp_cooldown_timer  = attack_cooldown
	enemy_idle()

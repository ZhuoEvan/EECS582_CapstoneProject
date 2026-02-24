extends CharacterBody2D
# ============================================= #
# Prologue Comment
#Name: Enemy movement/attack script
#Description: This .gd script provide the movement, attack and nessary information(health, damage, etc.) for the ebnemy characterr
#Authors: Zhang
#creation date: 2/23/26
#changes: created a basic enemy script where it will track and attack the player
#Preconditon: player exist in the scene
#Postcondition: follow player and attempt to attack
# ============================================= #

#tempoary value for the enemy
@export var health : int = 100
@export var damage : int = 10
@export var speed : float = 65.0
@export var attack_range : float = 3.0
@export var attack_cooldown : float = 1.0

#state for the enemy
enum State { IDLE, WALK, ATTACK }
var state: State = State.IDLE
#reference for player node
var player : Node2D
#flag to make sure enemy can't continous attack
var can_attack_flag := true

#ready function
func _ready() -> void:
	#Find the first node in the scene that belongs to the group "player"
	player = get_tree().get_first_node_in_group("player")
	#a safety check if player was not found
	if player == null:
		push_error("No player found in group 'player'")

#physic process for enemy
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
	#apply movement 
	move_and_slide()
	
#movement function
func move_toward_player() -> void:
	#Calculate direction vector from enemy to player
	var direction = (player.global_position - global_position).normalized()
	#Set velocity toward player
	velocity = direction * speed
	#change state to walk
	state = State.WALK
#start attack function
func start_attack() -> void:
	#only attack if cooldown alloes
	if can_attack_flag:
		#change stat to attack
		state = State.ATTACK
		#stop movement
		velocity = Vector2.ZERO
		#attack the player
		perform_attack()
#just a function to print out that enemy attack player
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

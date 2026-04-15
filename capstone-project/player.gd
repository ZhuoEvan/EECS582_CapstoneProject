# ============================================= #
# Prologue Comment
#Name: Player specific script
#Description: This .gd script provides player only methods.
#Authors: Zhang, Jace
#creation date: 3/4/26
#last modifed date:4/11/26
#changes: bug fix, player now can correctly died(Zhang)
#Preconditon: character script is created.
#Postcondition: Player will have own methods.
#
# ============================================= #

class_name Player
extends Character

#Handling Input Method
func handle_input() -> void:
	if state == State.DEATH:
		velocity = Vector2.ZERO
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	
	#Determine if it is Light ATK
	if can_attack() and Input.is_action_just_pressed("light_attack"):
		register_input("light_attack")
	#added heavy attack
	elif can_attack() and Input.is_action_just_pressed("heavy_attack"):
		register_input("heavy_attack")

#A list to store the possible combos
#can add more combo by using template {"name":"","sequence":[""],"result":STATE,"damage_multiplier": FLOAT}
#currently limit is 3 for attack list
var combo = [
	{"name": "Basic", "sequence":["light_attack","light_attack","heavy_attack"], "result":State.HEAVY_ATTACK,
	"damage_multiplier": 1.5}
]
#variable for combo system, Array is to track player input
var input_buffer: Array = []
var combo_timer := 0.0
var combo_window := 0.5
var current_damage_multiplier := 1.0
func _physics_process(delta: float) -> void:
	#using delta(current ingame time) to minus combo timer
	combo_timer -= delta
	#if combo timer is less than 0, reset the array and timer
	if combo_timer <=0:
		input_buffer.clear()
		combo_timer = 0
	super._physics_process(delta)
	# Route visibility to the correct sprite sheet for each special state
	var in_heavy = (state == State.HEAVY_ATTACK)
	var in_death = (state == State.DEATH)
	character_sprite.visible = !in_heavy and !in_death
	heavy_attack_sprite.visible = in_heavy
	death_sprite.visible = in_death
#helper function to register the input to compared to combo
func register_input(action: String) -> void:
	#append the input
	input_buffer.append(action)
	#set combo time to the .5s combo window
	combo_timer = combo_window
	#making sure that the buffer dont get overflow, pop the first element from the list
	if input_buffer.size() > 3:
		input_buffer.pop_front()
	#call function to check the combo
	check_combo()

#This is not really needed, this is for demo/testing the combo
#it just check if the combo is executed and print the combo name if it executed succefully
func check_combo() -> void:
	for i in combo:
		var seq = i["sequence"]
		if input_buffer.size() == seq.size():
			if input_buffer == seq:
				print("Combo:", i["name"])
				state = i["result"]
				current_damage_multiplier = i["damage_multiplier"]
				input_buffer.clear()
				combo_timer = 0
				return
	#call this function to handle basic attack
	damage_emitter.monitoring = true 
	handle_basic_attack()
	damage_emitter.monitoring = false

#handling case where player just hitting
func handle_basic_attack() -> void:
	#check if the buffer is empty
	if input_buffer.is_empty():
		return
	#set damage multiper to 1, since there is no combo
	current_damage_multiplier = 1.0
	#initializing a variable to keep track of the last attack input Player made
	var last_input = input_buffer[-1]
	#if it light attack, perform a light attack
	if last_input == "light_attack":
		state = State.LIGHT_ATTACK
		print("light attack")
	#if it is heavy attack, perform a heavy attack
	elif last_input == "heavy_attack":
		state = State.HEAVY_ATTACK
		print("heavy attack")
# References to the separate sprite sheet nodes
@onready var heavy_attack_sprite: Sprite2D = $HeavyAttackSprite
@onready var death_sprite: Sprite2D = $DeathSprite

# Override flip_sprites to keep all sprite sheets in sync with movement direction
func flip_sprites() -> void:
	super.flip_sprites()
	if velocity.x > 0:
		heavy_attack_sprite.flip_h = false
		death_sprite.flip_h = false
	elif velocity.x < 0:
		heavy_attack_sprite.flip_h = true
		death_sprite.flip_h = true

# Wait for the death animation to finish, then restart the current level.
# The await defers the scene change out of the physics frame that triggered death,
# which prevents the crash that happened when change_scene was called mid-frame.
func _on_died() -> void:
	await get_tree().create_timer(2.5).timeout
	get_tree().reload_current_scene()
#added a ready function to make sure player can died
func _ready() -> void:
	super._ready()
	if not died.is_connected(_on_died):
		died.connect(_on_died)

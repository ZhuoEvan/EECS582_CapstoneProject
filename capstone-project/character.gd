extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float

enum State { IDLE, WALK, ATTACK }
var state: State = State.IDLE
var attack_type := ""

func _process(_delta: float) -> void:
	handle_input()
	if state != State.ATTACK:
		handle_movement()
	handle_attacks()
	move_and_slide()

func handle_input() -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

	if can_attack() and Input.is_action_just_pressed("light_attack"):
		attack_type = "light_attack"
		state = State.ATTACK
	elif can_attack() and Input.is_action_just_pressed("heavy_attack"):
		attack_type = "heavy_attack"
		state = State.ATTACK

func handle_movement() -> void:
	if velocity.length() == 0:
		state = State.IDLE
	else:
		state = State.WALK

func handle_attacks() -> void:
	if state == State.ATTACK:
		print(attack_type)
		state = State.IDLE

func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK

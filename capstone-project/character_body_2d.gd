extends CharacterBody2D

@export var speed: float
func _process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * delta * speed
	velocity = direction * speed
	move_and_slide()

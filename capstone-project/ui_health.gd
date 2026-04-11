extends Control

# This exposes a slot in the Inspector so we can link the specific player character
@export var player: Player

# Grabs the Sprite2D node we just made
@onready var heart_sprite: Sprite2D = $HeartSprite 

func _ready() -> void:
	# Make sure the player is actually assigned before trying to connect
	if player:
		# Connect the player's health signal to our update function
		player.health_changed.connect(update_health_bar)
		
		# Set the initial UI state right when the game loads
		update_health_bar(player.health, player.max_health)
	else:
		push_warning("Player node not assigned to Health UI!")

func update_health_bar(current_health: int, max_health: int) -> void:
	# Prevent health from dropping below 0
	current_health = max(0, current_health)
	
	# Get the health percentage (a number between 0.0 and 1.0)
	var health_percent: float = float(current_health) / float(max_health)
	
	# Multiply the percentage by your total number of frames minus 1.
	# Since you have 17 frames, the frames are numbered 0 through 16.
	var total_frames_minus_one: int = 17 
	
	# Calculate which frame to show
	var target_frame: int = int(round(health_percent * total_frames_minus_one))
	
	# FLIP THE MATH HERE:
	heart_sprite.frame = 17 - target_frame
	
	# bug fix:Force immediate visual update on both the sprite and control(Zhang)
	heart_sprite.queue_redraw()
	queue_redraw()

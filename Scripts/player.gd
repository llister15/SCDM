extends KinematicBody2D
# Charater Name
export var name_of_char: String = "Turtle1"
# Character Movement
var velo: Vector2 = Vector2.ZERO
export var gravity: int = 30
export var move_speed: int = 40
export var max_speed: int = 160
export var jump_force: int = 515
var is_jumping: bool = false
# Character Stats
export var hp: int = 100
# Sounds
var jumpsfx = AudioStreamPlayer.new();

func _physics_process(delta: float) -> void:
	movement()
	velo = move_and_slide(velo, Vector2.UP)

# Getting input from user to add and subtract velocity values
func movement():
	# Creating varibles for user Input
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_just_pressed("jump")
	var cancel_jump = Input.is_action_just_released("jump")
	# if statements to Apply Input into movement
	if left and !right:
		# Animating the sprite
		$AnimatedSprite.play("Run")
		get_node("AnimatedSprite").set_flip_h(true)
		# Applying the user input into movement
		if velo.x < -max_speed:
			velo.x = -max_speed
		else:
			velo.x -= move_speed
	if right and !left:
		# Animating the sprite
		$AnimatedSprite.play("Run")
		get_node("AnimatedSprite").set_flip_h(false)
		if velo.x > max_speed:
			velo.x = max_speed
		else:
			velo.x += move_speed
	elif !left and !right:
		velo.x = lerp(velo.x, 0, 0.2)
		$AnimatedSprite.play("Idle")
	# Applying gravity on player
	velo.y += gravity
	if velo.y > gravity * 2:
		velo.y -= gravity / 2
	#jumping Section
	if jump and is_on_floor():
		is_jumping = true
		velo.y -= jump_force
		self.add_child(jumpsfx);
		jumpsfx.stream = load("res://Sounds/jumpsound.ogg");
		jumpsfx.play();
	elif cancel_jump and !is_on_floor() and is_jumping == true:
		if velo.y < 0:
			velo.y += jump_force / 4
		else:
			is_jumping = false

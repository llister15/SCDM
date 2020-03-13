extends KinematicBody2D
# Charater Name
export var name_of_char: String = "Turtle1"
# Character Movement
var velo: Vector2 = Vector2.ZERO
export var gravity: int = 30
export var move_speed: int = 40
export var max_speed: int = 200
export var jump_force: int = 500
var is_jumping: bool = false
# Character Stats
export var hp: int = 100

func _physics_process(delta: float) -> void:
	movement()
	velo = move_and_slide(velo, Vector2.UP)

# Getting input from user to add and subtract velocity values
func movement():
	# Creating varibles for user Input
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("jump")
	# if statements to Apply Input into movement
	if left and !right:
		# Animating the sprite
		pass ####
		# Applying the user input into movement
		if velo.x < -max_speed:
			velo.x = -max_speed
		else:
			velo.x -= move_speed
	if right and !left:
		# Animating the sprite
		pass ####
		if velo.x > max_speed:
			velo.x = max_speed
		else:
			velo.x += move_speed
	elif !left and !right and !jump:
		velo.x = lerp(velo.x, 0, 0.2)
		pass ####
	# Applying gravity on player
	velo.y += gravity
	if velo.y > gravity * 2:
		velo.y -= gravity / 2
	#jumping Section
	if jump and is_on_floor():
		is_jumping = true
		velo.y -= jump_force
		$JumpSound.play()
	# Setting bool is_jumping back to false
	if !jump and is_on_floor():
		is_jumping = false
	print(is_jumping)

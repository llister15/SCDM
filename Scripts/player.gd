extends Actor

# Getting input from user to add and subtract velocity values
func movement():
	var max_velo = 200
	# Creating varibles for user Input
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_just_pressed("jump")
	var cancel_jump = Input.is_action_just_released("jump")
	# Applying gravity on player
	velo.y += gravity
	# if statements to Apply Input into movement
	if left and !right:
		# Animating the sprite
		$AnimatedSprite.play("Run")
		get_node("AnimatedSprite").set_flip_h(true)
		# Applying the user input into movement
		if velo.x < -max_velo:
			velo.x = -max_velo
		else:
			velo.x -= move_speed
	if right and !left:
		# Animating the sprite
		$AnimatedSprite.play("Run")
		get_node("AnimatedSprite").set_flip_h(false)
		# Applying the user input into movement
		if velo.x > max_velo:
			velo.x = max_velo
		else:
			velo.x += move_speed
	elif !left and !right:
		velo.x = lerp(velo.x, 0, 0.2)
		if is_on_floor():
			$AnimatedSprite.play("Idle")
	#jumping Section
	if jump and is_on_floor():
		is_jumping = true
		velo.y -= jump_force
	elif cancel_jump and !is_on_floor():
		if velo.y < 0:
			velo.y = 0
	else:
		is_jumping = false

func _physics_process(delta: float) -> void:
	movement()
	velo = move_and_slide(velo, Vector2.UP)
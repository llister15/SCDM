extends KinematicBody2D
# Charater Name
export var name_of_char: String = "Turtle1"
# Character Movement
var velo: Vector2 = Vector2.ZERO
export var gravity: float = 40.0
export var move_speed: int = 50
export var max_speed: int = 200
export var jump_force: int = 600
var is_jumping: bool = false
# Character Stats
export var hp: int = 100
#State Transitions (animation)
var state_machine

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	movement()
	velo = move_and_slide(velo, Vector2.UP)

# Getting input from user to add and subtract velocity values
func movement():
	var curAnim = state_machine.get_current_node()
	# Creating varibles for user Input
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("jump")
	# if statements to Apply Input into movement
	if left and !right:
		# Applying the user input into movement
		if velo.x < -max_speed:
			velo.x = -max_speed
		else:
			velo.x -= move_speed
		$Sprite.scale.x = -1
	if right and !left:
		if velo.x > max_speed:
			velo.x = max_speed
		else:
			velo.x += move_speed
		$Sprite.scale.x = 1
	elif !left and !right:
		velo.x = 0
		#velo.x = lerp(velo.x, 0, .8)
		#if velo.x < 0.000002 or velo.x > -0.000002:
			#velo.x = 0
	if velo.x == 0:
		state_machine.travel('Idle')
	if velo.x != 0:
		state_machine.travel('Run')
	# Applying gravity on player
	velo.y += gravity
	if velo.y > gravity * 2:
		velo.y -= gravity / 2
	#jumping Section
	if jump and is_on_floor():
		is_jumping = true
		velo.y -= jump_force
		state_machine.travel('Jump')
		$JumpSound.play()
	# Setting bool is_jumping back to false
	if !jump and is_on_floor():
		is_jumping = false
	print(is_jumping)
	print(velo.x)
	print(curAnim)

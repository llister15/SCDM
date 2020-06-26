extends KinematicBody2D
# Charater Name
export var name_of_char: String = "Turtle1"
# Character movement
var velo: Vector2 = Vector2.ZERO
export var gravity: float = 40.0
export var move_speed: int = 50
export var max_speed: int = 200
var direction_right: bool = true
export var jump_force: int = 600
var is_jumping: bool = false
# Character Stats
const MAX_HP: int = 100
export var hp: int = MAX_HP
export var armour: int = 0
#animation machine
var state_machine
#loading weapons
var g19_scene = preload("res://Scenes/Assets/Glock19.tscn")

##Max values
#var RELOAD_TIME_MAX: float = 0.5
#var MAG_SIZE_MAX: int = 20
#var FIRE_RATE_MAX: float = 0.5
##varible values
#var reload_time: float = 0.0
#var mag_size: int = 20
#var fire_rate: float = 0.5
#
#func _process(delta: float) -> void:
#	fire_rate -= delta
#	print(fire_rate)

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	pass

func _physics_process(delta):
	movement()
	Gravity()
	spawn_Weapon()
	#Shoot()
	velo = move_and_slide(velo, Vector2.UP)

# Getting input from user to add and subtract velocity values
func movement():
	var _curAnim = state_machine.get_current_node()
	# Creating varibles for user Input
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("jump")
	# if statements to Apply Input into movement
	if left and !right:
		direction_right = false
		# Applying the user input into movement
		if velo.x < -max_speed:
			velo.x = -max_speed
		else:
			velo.x -= move_speed
		$Sprite.scale.x = -1
	if right and !left:
		direction_right = true
		if velo.x > max_speed:
			velo.x = max_speed
		else:
			velo.x += move_speed
		$Sprite.scale.x = 1
	elif !left and !right:
		velo.x = 0
	if velo.x == 0:
		state_machine.travel('Idle')
	if velo.x != 0:
		state_machine.travel('Run')
	#jumping Section
	if jump and is_on_floor():
		is_jumping = true
		velo.y -= jump_force
		state_machine.travel('Jump')
		$JumpSound.play()
	# Setting bool is_jumping back to false
	if !jump and is_on_floor():
		is_jumping = false

func Gravity():
	velo.y += gravity

func spawn_Weapon():
	var spawn_gun = Input.is_action_just_pressed("fire2")
	var g19_Gun = g19_scene.instance()
	if spawn_gun:
		get_parent().add_child(g19_Gun)
	g19_Gun.position = $"Sprite/Weapon equiper".global_position
	g19_Gun.rotation_degrees = get_global_mouse_position().x

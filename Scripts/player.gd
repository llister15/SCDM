extends KinematicBody2D
# Charater Name
export var name_of_char: String = "Turtle1"
# Character movement
var velo: Vector2 = Vector2.ZERO
export var gravity: float = 40.0
export var move_speed: int = 50
export var max_speed: int = 200
var mouseTarget: Vector2 = Vector2.ZERO
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
var g19_Gun = g19_scene.instance()

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
	velo = move_and_slide(velo, Vector2.UP)

# Getting input from user to add and subtract velocity values
func movement():
	var _curAnim = state_machine.get_current_node()
	mouseTarget = get_global_mouse_position() - get_global_position()
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
	if right and !left:
		if velo.x > max_speed:
			velo.x = max_speed
		else:
			velo.x += move_speed
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
	#aiming
	#print(atan2(mouseTarget.y, mouseTarget.x))
	if mouseTarget.x < 0:
		$Sprite.scale.x = -1
	else:
		$Sprite.scale.x = 1
func Gravity():
	velo.y += gravity

func spawn_Weapon():
	var spawn_gun = Input.is_action_just_pressed("fire2")
	mouseTarget = get_global_mouse_position() - get_global_position()
	if spawn_gun:
		get_tree().get_root().add_child(g19_Gun)
	g19_Gun.position = $"Sprite/Weapon equiper".global_position
	g19_Gun.rotation = atan2(mouseTarget.y, mouseTarget.x)
	get_node("Camera2D/Label").text = str(g19_Gun.mag_size)
	

func equip_Weapon():
	var equip = Input.is_action_just_pressed("Interact")
	if collision_mask == 1:
		get_node_or_null("g19_Gun").position = $"Sprite/Weapon equiper".global_position

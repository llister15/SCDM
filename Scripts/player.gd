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
const MAX_ARMOUR: int = 50
export var armour: int = MAX_ARMOUR
#Loading HUD
var HUD_scene = preload("res://Scenes/Assets/HUD.tscn")
var HUD_display = HUD_scene.instance()
#animation machine
var state_machine
#Loading weapons
var g19_scene = preload("res://Scenes/Assets/Glock19.tscn")
var g19_Gun = g19_scene.instance()
var weapon_equiped: bool = false
var weapon_equiperoffset

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	$"Camera2D".add_child(HUD_display)
	HUD_display.get_node("CanvasLayer/Character_stats/Health Bar").value = MAX_HP
	

func _physics_process(delta):
	movement()
	Gravity()
	Health()
	spawn_Weapon()
	velo = move_and_slide(velo, Vector2.UP)

# Getting input from user to add and subtract velocity values
func movement():
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

func Health():
	if hp <= 0:
		queue_free()

func spawn_Weapon():
	var spawn_gun = Input.is_action_just_pressed("fire2")
	mouseTarget = get_global_mouse_position() - $"Sprite/Weapon equiper".global_position
	weapon_equiperoffset = get_global_mouse_position() - $"Sprite/Weapon equiper".global_position
	weapon_equiperoffset = weapon_equiperoffset.normalized() * 15
	print(g19_Gun.position)
	if spawn_gun:
		get_node("Sprite/Weapon equiper").add_child(g19_Gun)
	if mouseTarget.x < 0:
		g19_Gun.position = $"Sprite/Weapon equiper".position - Vector2(weapon_equiperoffset.x, -weapon_equiperoffset.y)
		g19_Gun.get_node("Muzzle Position").position.x = -9.6
		g19_Gun.get_node("Sprite").set_flip_h(true)
		g19_Gun.rotation = -atan2(mouseTarget.y, mouseTarget.x)
	else:
		g19_Gun.position = $"Sprite/Weapon equiper".position + weapon_equiperoffset
		g19_Gun.get_node("Muzzle Position").position.x = 9.6
		g19_Gun.get_node("Sprite").set_flip_h(false)
		g19_Gun.rotation = atan2(mouseTarget.y, mouseTarget.x)
	HUD_display.get_node("CanvasLayer/Weapon_ui/Ammo_Label").text = str(g19_Gun.mag_size)

func equip_Weapon():
	var equip = Input.is_action_just_pressed("Interact")
	if collision_mask == 1:
		get_node_or_null("g19_Gun").position = $"Sprite/Weapon equiper".global_position

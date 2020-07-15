extends KinematicBody2D

# Charater Name
export var name_of_char: String = "Turtle1"
# Character movement
var velo: Vector2
var last_velo: Vector2
export var move_speed: int = 40
export var max_speed: int = 150
export var gravity: float = 20.0
export var jump_force: int = 380
export var jump_count: int = 0
var is_jumping: bool = false
var can_jump: bool = false
var mouseTarget: Vector2 = Vector2.ZERO
# Character Stats
export var MAX_HP: int = 100
export var hp: int = MAX_HP
export var MAX_ARMOUR: int = 50
export var armour: int = MAX_ARMOUR
#Loading HUD
var HUD_scene = preload("res://Scenes/Assets/HUD.tscn")
var HUD_display = HUD_scene.instance()
#animation machine
var state_machine
#Equiping weapons
var equip_radius: bool = false
var weapon_equiped: bool = false
var weapon_equiperoffset

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	$"Camera2D".add_child(HUD_display)
	HUD_display.get_node("CanvasLayer/Character_stats/Health Bar").value = MAX_HP
	
	mouseTarget = get_global_mouse_position() - $"Sprite/Weapon equiper".global_position
	weapon_equiperoffset = get_global_mouse_position() - $"Sprite/Weapon equiper".global_position
	weapon_equiperoffset = weapon_equiperoffset.normalized() * 10

# calls function every frame also handles physics greater
func _physics_process(delta):
	movement()
	Gravity()
	Health()
	equip_weapon()
	respawn()
	velo = move_and_slide(velo, Vector2.UP)

# Getting input from user to add and subtract velocity values
func movement():
	mouseTarget = get_global_mouse_position() - get_global_position()
	# Creating varibles for user Input
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_just_pressed("jump")
	# if statements to Apply Input into movement
	if left and !right:
		# Applying the user input into movement
		if velo.x < -max_speed:
			velo.x = -max_speed
		else:
			velo.x -= move_speed
		last_velo = velo
	if right and !left:
		if velo.x > max_speed:
			velo.x = max_speed
		else:
			velo.x += move_speed
		last_velo = velo
	elif !left and !right:
		last_velo = Vector2.ZERO
		velo.x = lerp(velo.x, last_velo.x, 0.25)
	if velo.x > -10 or velo.x < 10:
		state_machine.travel('Idle')
	if velo.x < -10 or velo.x > 10:
		state_machine.travel('Run')
	#jumping Section
	if is_on_floor():
		can_jump = true
		is_jumping = false
		jump_count = 0
	# Player Jump statement
	if jump && jump_count < 2 && can_jump == true:
		velo.y = 0
		velo.y -= jump_force
		jump_count += 1
		is_jumping = true
		state_machine.travel('Jump')
		$JumpSound.play()
	# Coyote Jumping
	if !is_on_floor() && !is_jumping:
		yield(get_tree().create_timer(0.3), "timeout")
		if is_jumping:
			can_jump = true
		else:
			can_jump = false
	#flipping the sprite to look in the correct direction
	if mouseTarget.x < 0:
		$Sprite.scale.x = -1
	else:
		$Sprite.scale.x = 1

# adding gravity to player
func Gravity():
	velo.y += gravity
	if velo.y > gravity * 40:
		velo.y -= gravity

# adding health to player
func Health():
	if hp <= 0:
		queue_free()

# Equip weapon interaction
func equip_weapon():
	var equip = Input.is_action_just_pressed("Interact")
	if equip:
		if equip_radius == true and weapon_equiped == false:
			weapon_equiped = true
			
	
# developer to test gravity /// get to high places with right click
func respawn():
	var rClick = Input.is_action_pressed("fire2")
	if rClick:
		self.position.y = self.global_position.y - 30
	
	
#func spawn_Weapon():
#	var spawn_gun = Input.is_action_just_pressed("fire2")
#	mouseTarget = get_global_mouse_position() - $"Sprite/Weapon equiper".global_position
#	weapon_equiperoffset = get_global_mouse_position() - $"Sprite/Weapon equiper".global_position
#	weapon_equiperoffset = weapon_equiperoffset.normalized() * 10
#	if spawn_gun:
#		get_node("Sprite/Weapon equiper").add_child(Glock)
#	if mouseTarget.x < 0:
#		Glock.position = $"Sprite/Weapon equiper".position - Vector2(weapon_equiperoffset.x, -weapon_equiperoffset.y)
#		Glock.get_node("Muzzle Position").position.x = -9.6
#		Glock.get_node("Sprite").set_flip_h(true)
#		Glock.rotation = -atan2(mouseTarget.y, mouseTarget.x)
#	else:
#		Glock.position = $"Sprite/Weapon equiper".position + weapon_equiperoffset
#		Glock.get_node("Muzzle Position").position.x = 9.6
#		Glock.get_node("Sprite").set_flip_h(false)
#		Glock.rotation = atan2(mouseTarget.y, mouseTarget.x)
#	HUD_display.get_node("CanvasLayer/Weapon_ui/Ammo_Label").text = str(Glock.mag_size)
#	if Glock.mag_size <= 0:
#		HUD_display.get_node("CanvasLayer/Weapon_ui/Ammo_Label").text = str("Press R to Reload")





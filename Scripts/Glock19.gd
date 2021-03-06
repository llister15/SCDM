extends RigidBody2D

# Max values |||||||||||||||||||
var RELOAD_TIME_MAX: float = 0.5
var MAG_SIZE_MAX: int = 15
var FIRE_RATE_MAX: float = 0.01
# varible values |||||||||||||||||||
var mag_size: int = MAG_SIZE_MAX
var fire_rate: float = FIRE_RATE_MAX
var bulletSpeed: float = 1500.0
var is_reloading: bool = false
var Damage: int = 25
# equipping |||||||||||||||||||
var is_equiped: bool = false
# point to cursor |||||||||||||||||||
var mouseTarget: Vector2 = Vector2.ZERO
var mouseDirection: float = 0

# preload ammo |||||||||||||||||||
var bullet_scene = preload("res://Scenes/Assets/9mm.tscn")


func _process(delta):
	Shoot()
	Reload()
	fire_rate -= delta
	if fire_rate < 0:
		fire_rate = 0

func Shoot():
	var shoot_gun = Input.is_action_just_pressed("fire1")
	var bullet_instance = bullet_scene.instance()
	mouseTarget = get_global_mouse_position() - $"Muzzle Position".global_position
	if shoot_gun and is_reloading == false and is_equiped == true:
		if fire_rate <= 0 and mag_size > 0:
			$"9mm_shot".play()
			$"Muzzle Position/Particles2D".set_emitting(true)
			fire_rate = FIRE_RATE_MAX
			mag_size -= 1
			get_tree().get_root().add_child(bullet_instance)
			bullet_instance.position = $"Muzzle Position".global_position
			if mouseTarget.x < 0:
				bullet_instance.get_node("Sprite").set_flip_h(true)
				bullet_instance.rotation = $"Muzzle Position".global_rotation
			if mouseTarget.x > 0:
				bullet_instance.get_node("Sprite").set_flip_h(false)
				bullet_instance.rotation = $"Muzzle Position".global_rotation
			bullet_instance.apply_impulse(Vector2(), Vector2(mouseTarget.normalized().x * bulletSpeed, mouseTarget.normalized().y * bulletSpeed))
			

func Reload():
	var reload = Input.is_action_just_pressed("Reload")
	if reload and mag_size < MAG_SIZE_MAX and is_equiped == true:
		is_reloading = true
		$"ejecting_magazine".play()
		yield(get_tree().create_timer(RELOAD_TIME_MAX), "timeout")
		$"pop_clip_in".play()
		yield(get_tree().create_timer(RELOAD_TIME_MAX / 5), "timeout")
		mag_size = MAG_SIZE_MAX
		is_reloading = false
#	if mag_size <= 0 and is_reloading == false:
#		is_reloading = true
#		$"ejecting_magazine".play()
#		yield(get_tree().create_timer(RELOAD_TIME_MAX), "timeout")
#		$"pop_clip_in".play()
#		yield(get_tree().create_timer(RELOAD_TIME_MAX / 5), "timeout")
#		mag_size = MAG_SIZE_MAX
#		is_reloading = false
	if is_reloading == true and Input.is_action_just_pressed("fire1"):
		$"dry_fire".play()
	elif mag_size <= 0 and Input.is_action_just_pressed("fire1"):
		$"dry_fire".play()


#func _on_Equip_Area_body_entered(body):
#	if body.name == "Player" and is_equiped == false:
#		queue_free()
#	print(is_equiped)

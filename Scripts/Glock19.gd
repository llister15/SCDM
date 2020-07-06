extends RigidBody2D

#Max values
var RELOAD_TIME_MAX: float = 1.0
var MAG_SIZE_MAX: int = 15
var FIRE_RATE_MAX: float = 0.1
#varible values
var reload_time: float = RELOAD_TIME_MAX
var mag_size: int = MAG_SIZE_MAX
var fire_rate: float = FIRE_RATE_MAX
var bulletSpeed: float = 1000.0
var is_reloading: bool = false
var Damage: int = 0

var mouseTarget: Vector2 = Vector2.ZERO
var mouseDirection: float = 0

#preload ammo
var bullet_scene = preload("res://Scenes/Assets/9mm.tscn")


func _physics_process(delta):
	Shoot()
	Reload()
	fire_rate -= delta
	if fire_rate < 0:
		fire_rate = 0

func Shoot():
	var shoot_gun = Input.is_action_just_pressed("fire1")
	var bullet_instance = bullet_scene.instance()
	mouseTarget = get_global_mouse_position() - $"Muzzle Position".global_position
	if shoot_gun and is_reloading == false:
		if fire_rate <= 0 and mag_size > 0:
			$"9mm_shot".play()
			fire_rate = FIRE_RATE_MAX
			mag_size -= 1
			get_tree().get_root().add_child(bullet_instance)
			bullet_instance.position = $"Muzzle Position".global_position
			bullet_instance.rotation = $"Muzzle Position".global_rotation 
			bullet_instance.apply_impulse(Vector2(), Vector2(mouseTarget.normalized().x * bulletSpeed, mouseTarget.normalized().y * bulletSpeed))
	

func Reload():
	var reload = Input.is_action_just_pressed("Reload")
	print(is_reloading)
	if reload and mag_size < MAG_SIZE_MAX:
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

extends RigidBody2D

#Max values
var RELOAD_TIME_MAX: float = 0.5
var MAG_SIZE_MAX: int = 10
var FIRE_RATE_MAX: float = 0.1
#varible values
var reload_time: float = RELOAD_TIME_MAX
var mag_size: int = MAG_SIZE_MAX
var fire_rate: float = FIRE_RATE_MAX
var bulletSpeed: float = 1200.0

var mouseTarget: Vector2 = Vector2.ZERO
var mouseDirection: float = 0




#preload ammo
var bullet_scene = preload("res://Scenes/Assets/9mm.tscn")

func _physics_process(delta):
	Shoot()
	fire_rate -= delta
	if fire_rate < 0:
		fire_rate = 0

func Shoot():
	var shoot_gun = Input.is_action_pressed("fire1")
	var reload = Input.is_action_just_pressed("Reload")
	var bullet_instance = bullet_scene.instance()
	var bullet_rotation = get_angle_to(get_global_mouse_position()) + self.get_rotation()
	bullet_instance.set_rotation(bullet_rotation)
	bullet_instance.set_position(self.global_position)
	mouseTarget = get_global_mouse_position() - $"Muzzle Position".global_position
	
#	print(str(Vector2($"Muzzle Position".global_position)))
	print(mouseTarget.normalized())
	
	if shoot_gun:
		if fire_rate <= 0 and mag_size > 0:
			fire_rate = FIRE_RATE_MAX
			mag_size -= 1
			get_tree().get_root().add_child(bullet_instance)
			bullet_instance.position = $"Muzzle Position".global_position
			bullet_instance.rotation = $"Muzzle Position".global_rotation 
			bullet_instance.apply_impulse(Vector2(), Vector2(mouseTarget.normalized().x * bulletSpeed, mouseTarget.normalized().y * bulletSpeed))
			
		
	if reload:
		mag_size = MAG_SIZE_MAX

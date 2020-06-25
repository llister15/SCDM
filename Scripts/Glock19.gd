extends Sprite

const bulletscene = preload("res://Scenes/Assets/9mm.tscn")


func _physics_process(delta):
	bullet_travel()

func bullet_travel():
	var user_shoot = Input.is_action_just_pressed("fire1")
	var bullet = bulletscene.instance()
	if user_shoot:
		add_child(bullet)
		bullet.global_position = global_position
	
	

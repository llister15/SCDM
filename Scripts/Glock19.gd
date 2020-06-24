extends Area2D

onready var bulletscene = load("res://Scenes/Assets/9mm.tscn")

func _ready() -> void:
	 pass

func _physics_process(delta):
	bullet_travel()

func bullet_travel():
	var user_shoot = Input.is_action_just_pressed("fire1")
	if user_shoot:
		var bullet = bulletscene.instance()
		get_parent().add_child(bullet)
		bullet.transform = $Muzzle.global_transform

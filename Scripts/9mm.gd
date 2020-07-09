extends RigidBody2D

var bullet_timer: float = 3.0

func _physics_process(delta):
	pass

func _on_VisibilityNotifier2D_screen_exited() -> void:
	yield(get_tree().create_timer(bullet_timer), "timeout")
	queue_free()

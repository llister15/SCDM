extends RigidBody2D

var bullet_timer: float = 2.0

func _physics_process(delta):
#	bullet_timeout()
	pass
	
	
func bullet_timeout():
	yield(get_tree().create_timer(bullet_timer), "timeout")
	queue_free()

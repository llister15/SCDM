extends Area2D

var Speed: int = 400
var bullet_velo = Vector2.ZERO

func _physics_process(delta):
	bullet()
	
func bullet():
	position += transform.x * Speed * get_physics_process_delta_time()



func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

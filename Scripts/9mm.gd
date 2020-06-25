extends Area2D

export(float) var Speed = 1500
export(float) var Damage = 25

var direction = 0

func _ready():
	set_as_toplevel(true)
	
func _process(delta):
	position.x += direction * Speed * delta




func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

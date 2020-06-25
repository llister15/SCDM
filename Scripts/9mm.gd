extends RigidBody2D

export(float) var Speed = 1500
export(float) var Damage = 25

var cur_velo: Vector2 = Vector2.ZERO
var new_velo: Vector2 = Vector2.ZERO

func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

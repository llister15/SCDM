extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var jumpsfx = AudioStreamPlayer.new()
	self.add_child(jumpsfx)
	jumpsfx.stream = load("res://Sounds/jumpsound.ogg")

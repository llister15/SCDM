extends Node2D

var g19_scene = preload("res://Scenes/Assets/Glock19.tscn")
var ar15_scene = preload("res://Scenes/Assets/AR15.tscn")
var shotgun_scene = preload("res://Scenes/Assets/shotgun.tscn")

func _ready():
	var Glock = g19_scene.instance()
	var ar15 = ar15_scene.instance()
	var shotgun = shotgun_scene.instance()
	add_child(Glock)
	add_child(ar15)
	add_child(shotgun)

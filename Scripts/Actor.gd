# imports all functions and classes
extends KinematicBody2D
# Creating a class for multiple Characters
class_name Actor, "res://Sprites/Turtle.png"

# Charater Name
var name_of_char: String = "Turtle1"
# Character Movement
var gravity: int = 20
var velo: Vector2 = Vector2.ZERO
var move_speed: int = 15
var jump_force: int = 475
var is_jumping: bool = false
# Character Stats
var hp: int = 100
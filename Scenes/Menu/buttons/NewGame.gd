extends Control

func _on_New_Game_pressed():
	get_tree().change_scene("res://Scenes/Levels/Test Movement World.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()

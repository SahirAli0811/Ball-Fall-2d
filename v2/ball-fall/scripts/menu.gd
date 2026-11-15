extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_play_2_pressed():
	get_tree().change_scene_to_file("res://scenes/game_2.tscn")

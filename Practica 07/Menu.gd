extends Node2D


func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://Level_1.tscn")


func _on_creditos_pressed():
	get_tree().change_scene_to_file("res://thanks.tscn")

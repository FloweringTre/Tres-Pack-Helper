extends Control


var agreed : bool = false

func _ready() -> void:
	$TextureRect.self_modulate = Color (1, 1, 1, 1)
	$TextureRect.visible = true
	$Timer.start(1)
	%confirmButton.disabled = true
	#print("starting timer")

func _on_back_button_pressed() -> void:
	get_tree().quit()


func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/startingGUI.tscn")


func _on_check_box_pressed() -> void:
	if agreed:
		agreed = false
		%confirmButton.disabled = true
		$NinePatchRect/continue.add_theme_color_override("font_color", Color(0.50, 0.51, 0.36))
	else:
		agreed = true
		%confirmButton.disabled = false
		$NinePatchRect/continue.add_theme_color_override("font_color", Color(0.28, 0.46, 0.16))


func _on_timer_timeout() -> void:
	#print("starting animation")
	$AnimationPlayer.play("fade")

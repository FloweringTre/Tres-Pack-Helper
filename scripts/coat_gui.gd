extends Control

var breedable : bool = true
var cyclable : bool = true
var basecolors : Array

func _ready() -> void:
	ErrorManager.error_alert.connect(on_error)

func on_error() -> void:
	%confirmButton.disabled = true
	%backButton.disabled = true

func on_error_continue() -> void:
	%confirmButton.disabled = true
	%backButton.disabled = false

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func _on_confirm_button_pressed() -> void:
	basecolors = %baseColorsItemList.get_selected_items()
	store_base_colors()
	print(basecolors)

func _on_artist_text_text_changed() -> void:
	pass # Replace with function body.

func _on_inspo_text_text_changed() -> void:
	pass # Replace with function body.

func _on_coat_text_text_changed() -> void:
	pass # Replace with function body.

func _on_breeding_check_box_pressed() -> void:
	if breedable:
		breedable = false
		%breedingLabel.text = "No"
	else:
		breedable = true
		%breedingLabel.text = "Yes"

func _on_lapis_check_box_pressed() -> void:
	if cyclable:
		cyclable = false
		%lapisLabel.text = "No"
	else:
		cyclable = true
		%lapisLabel.text = "Yes"

func store_base_colors():
	var temp_array = []
	for color in basecolors:
		match color:
			0:
				temp_array.append("black")
			1:
				temp_array.append("brown")
			2:
				temp_array.append("chestnut")
			3:
				temp_array.append("creamy")
			4:
				temp_array.append("dark_brown")
			5:
				temp_array.append("gray")
			6:
				temp_array.append("white")
	basecolors = temp_array
	return basecolors

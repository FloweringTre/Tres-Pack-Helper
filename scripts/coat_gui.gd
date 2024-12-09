extends Control

var breedable : bool = true
var cyclable : bool = true
var basecolors : Array
var black_coat : bool = false
var gray_coat : bool = false
var white_coat : bool = false
var creamy_coat : bool = false
var brown_coat : bool = false
var dark_brown_coat : bool = false
var chestnut_coat : bool = false
var artist : bool = false
var inspo : bool = false
var coat_name : bool = false
var file_name : String
var path : String

signal new_coat_saved

func _ready() -> void:
	ErrorManager.error_alert.connect(on_error)
	$errorMessage.error_continue.connect(on_error_continue)
	%n_aButton.button_pressed.connect(on_NA_button)
	%nameCheck.button_pressed.connect(on_name_check)
	new_coat_saved.connect(on_new_coat_saved)
	$popUP_Saved.deny.connect(on_popup_saved_back)
	$popUP_Saved.confirm.connect(on_popup_saved_confirmed)
	$popUP2_Dupe.deny.connect(on_popup_dupe_back)
	$popUP2_Dupe.confirm.connect(on_popup_dupe_confirmed)

func on_error() -> void:
	%confirmButton.disabled = true
	%backButton.disabled = true
	%artistText.editable = false
	%inspoText.editable = false
	%coatText.editable = false
	%n_aButton.set_disabled()
	%nameCheck.set_disabled()

func on_error_continue() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%coatText.editable = true
	%n_aButton.reenable_button()
	%nameCheck.reenable_button()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func _on_artist_text_text_changed() -> void:
	if %artistText.text != "":
		artist = true
		if coat_name == true && inspo == true:
			%confirmButton.disabled = false
		else:
			pass
	else:
		artist = false
		%confirmButton.disabled = true

func _on_inspo_text_text_changed() -> void:
	if %inspoText.text != "":
		inspo = true
		if artist == true && coat_name == true:
			%confirmButton.disabled = false
		else:
			pass
	else:
		inspo = false
		%confirmButton.disabled = true

func on_NA_button() -> void:
	%inspoText.text = "N/a"
	inspo = true
	if artist == true && coat_name == true:
		%confirmButton.disabled = false
	else:
		pass

func _on_coat_text_text_changed() -> void:
	$checkPath.awaiting_check()
	coat_name = false
	%confirmButton.disabled = true

func on_name_check() -> void:
	if %coatText.text == "":
		$checkPath.set_check(false)
		coat_name = false
	else:
		%coatText.text = GlobalScripts.text_clean(%coatText.text)
		$checkPath.set_check(true)
		coat_name = true
		if artist == true && inspo == true:
			%confirmButton.disabled = false
		else:
			pass

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

func _on_black_check_box_pressed() -> void:
	if black_coat:
		black_coat = false
		basecolors.erase("black")
	else:
		black_coat = true
		basecolors.append("black")

func _on_gray_check_box_2_pressed() -> void:
	if gray_coat:
		gray_coat = false
		basecolors.erase("gray")
	else:
		gray_coat = true
		basecolors.append("gray")

func _on_white_check_box_3_pressed() -> void:
	if white_coat:
		white_coat = false
		basecolors.erase("white")
	else:
		white_coat = true
		basecolors.append("white")

func _on_creamy_check_box_4_pressed() -> void:
	if creamy_coat:
		creamy_coat = false
		basecolors.erase("creamy")
	else:
		creamy_coat = true
		basecolors.append("creamy")

func _on_brown_check_box_5_pressed() -> void:
	if brown_coat:
		brown_coat = false
		basecolors.erase("brown")
	else:
		brown_coat = true
		basecolors.append("brown")

func _on_d_brown_check_box_6_pressed() -> void:
	if dark_brown_coat:
		dark_brown_coat = false
		basecolors.erase("dark_brown")
	else:
		dark_brown_coat = true
		basecolors.append("dark_brown")

func _on_chestnut_check_box_7_pressed() -> void:
	if chestnut_coat:
		chestnut_coat = false
		basecolors.erase("chestnut")
	else:
		chestnut_coat = true
		basecolors.append("chestnut")

func _on_confirm_button_pressed() -> void:
	GlobalScripts.setup_coats()
	on_name_check()
	file_name = %coatText.text + ".json"
	path = GlobalScripts.join_paths(GlobalScripts.jsons_root, "coats")
	path = GlobalScripts.join_paths(path, file_name)
	
	if GlobalScripts.check_file_exists(path):
		coat_exists()
	else:
		save_coat()

func save_coat() -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		var models = {
			"legacy" = "legacy/" + %coatText.text + ".png"
		}
		var part_1 = {
			"credits" = %artistText.text,
			"inspiration" = %inspoText.text,
			"models" = models,
			"lapis_cyclable" = cyclable,
			"obtainable_by_breeding" = breedable,
			"base_colors" = basecolors
		}
		
		var string_1 = JSON.stringify(part_1)
		
		file.store_string(string_1)
		file.close()
		GlobalScripts.instructions_coat(%coatText.text, GlobalScripts.join_paths(GlobalScripts.textures_root, "coats/legacy") )
		GlobalScripts.report("Saved the new coat, " + %coatText.text + ", to " + path)
		new_coat_saved.emit()
	
	else:
		ErrorManager.error_print("I couldn't save the new coat. The ./json/coat/ folder wouldn't open. Check to see if it exists.")
		GlobalScripts.report("Failed to save the new coat, '" + %coatText.text + "' to " + path)

func coat_exists() -> void:
	var title = "This coat already exists!"
	var message = "There already exists a coat named '" + %coatText.text + "'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Overwrite it"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	%confirmButton.disabled = true
	%backButton.disabled = true
	%artistText.editable = false
	%inspoText.editable = false
	%coatText.editable = false
	%n_aButton.set_disabled()
	%nameCheck.set_disabled()

func on_popup_dupe_back() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%coatText.editable = true
	%n_aButton.reenable_button()
	%nameCheck.reenable_button()

func on_popup_dupe_confirmed() -> void:
	save_coat()

func on_new_coat_saved() -> void:
	var title = "Complete!"
	var message = "Successfully added '" + %coatText.text + "' to the pack folder. \nWhat do you want to do now?"
	var no_label = "Go Back"
	var yes_label = "Start New Coat"
	$popUP_Saved.pop_yesNo(title, message, no_label, yes_label)
	%confirmButton.disabled = true
	%backButton.disabled = true
	%artistText.editable = false
	%inspoText.editable = false
	%coatText.editable = false
	%n_aButton.set_disabled()
	%nameCheck.set_disabled()

func on_popup_saved_back() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%coatText.editable = true
	%n_aButton.reenable_button()
	%nameCheck.reenable_button()

func on_popup_saved_confirmed() -> void:
	get_tree().reload_current_scene()

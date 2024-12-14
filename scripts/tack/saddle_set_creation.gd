extends Control

var artist : bool = false
var inspo : bool = false
var set_name : bool = false
var set_coin : bool = false

var sad_western : bool = true
var sad_english : bool = false
var bri_western : bool = true
var bri_english : bool = false
var bla_western : bool = true
var bla_english : bool = false
var adventure : bool = false

var custom_rack : bool = false
var red : float = 255.0
var green : float = 255.0
var blue : float = 255.0
var coin : String

var file_name : String
var path : String

signal new_tack_saved

func _ready() -> void:
	ErrorManager.error_alert.connect(on_error)
	$errorMessage.error_continue.connect(on_error_continue)
	new_tack_saved.connect(on_new_tack_saved)
	$popUP_Saved.deny.connect(on_popup_saved_back)
	$popUP_Saved.confirm.connect(on_popup_saved_confirmed)
	$popUP2_Dupe.deny.connect(on_popup_dupe_back)
	$popUP2_Dupe.confirm.connect(on_popup_dupe_confirmed)
	$popUPexit.deny.connect(on_popup_saved_back)
	$popUPexit.confirm.connect(on_popup_exit_confirmed)
	$helpscreen.visible = true
	starting_coin_values()
	if GlobalScripts.artist != "":
		%artistText.text = GlobalScripts.artist
		artist = true
		ready_to_save()

func on_error() -> void:
	disable_interaction()

func on_error_continue() -> void:
	enable_interaction()

func _on_back_button_pressed() -> void:
	if %artistText.text != "" or %inspoText.text != "" or %tackText.text != "":
		are_you_sure()
	else:
		get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

func disable_interaction() -> void:
	%confirmButton.disabled = true
	%backButton.disabled = true
	%artistText.editable = false
	%inspoText.editable = false
	%tackText.editable = false
	%armorCheckBox.disabled = true
	%custCheckBox.disabled = true
	%redSpinBox.editable = false
	%greenSpinBox.editable = false
	%blueSpinBox.editable = false
	%coinOptions.disabled = true
	%SaddleCheckButton.disabled = true
	%BridleCheckButton.disabled = true
	%BlanketCheckButton.disabled = true
	%saddleSpinBox.editable = false
	%bridleSpinBox.editable = false
	%blanketSpinBox.editable = false
	%legWrapsSpinBox.editable = false
	%breastCollarSpinBox.editable = false
	%girthStrapSpinBox.editable = false

func enable_interaction() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true
	%armorCheckBox.disabled = false
	%custCheckBox.disabled = false
	%redSpinBox.editable = true
	%greenSpinBox.editable = true
	%blueSpinBox.editable = true
	%coinOptions.disabled = false
	%SaddleCheckButton.disabled = false
	%BridleCheckButton.disabled = false
	%BlanketCheckButton.disabled = false
	%saddleSpinBox.editable = true
	%bridleSpinBox.editable = true
	%blanketSpinBox.editable = true
	%legWrapsSpinBox.editable = true
	%breastCollarSpinBox.editable = true
	%girthStrapSpinBox.editable = true

################### VALUE LOGGING ######################
func _on_artist_text_text_changed(new_text: String) -> void:
	if %artistText.text != "":
		artist = true
	else:
		artist = false
	ready_to_save()

func _on_inspo_text_text_changed(new_text: String) -> void:
	if %inspoText.text != "":
		inspo = true
	else:
		inspo = false

func _on_tack_text_text_changed(new_text: String) -> void:
	update_name_previews()
	if %tackText.text != "":
		set_name = true
	else:
		set_name = false
	ready_to_save()

func update_name_previews() -> void:
	var text = ""
	if %tackText.text == "":
		text = "Butterfly Morpho"
	else:
		text = %tackText.text
	%inGameLabel.text = text + " Bridle"
	%dataLabel.text = GlobalScripts.text_clean(text) + "_bridle"

func _on_armor_check_box_pressed() -> void:
	if adventure:
		adventure = false
		%armorLabel.text = "No"
	else:
		adventure = true
		%armorLabel.text = "Yes"

func _on_cust_check_box_pressed() -> void:
	if custom_rack:
		custom_rack = false
		%custLabel.text = "No"
		%STATICBoxContainer.visible = false
		%EDITBoxContainer.visible = true
	else:
		custom_rack = true
		%custLabel.text = "Yes"
		%STATICBoxContainer.visible = true
		%EDITBoxContainer.visible = false

func _on_red_spin_box_value_changed(value: float) -> void:
	red = %redSpinBox.value
	update_color_preview()

func _on_green_spin_box_value_changed(value: float) -> void:
	green = %greenSpinBox.value
	update_color_preview()

func _on_blue_spin_box_value_changed(value: float) -> void:
	blue = %blueSpinBox.value
	update_color_preview()

func update_color_preview() -> void:
	%colorPreview.color = Color(red/255, green/255, blue/255)

func _on_coin_options_item_selected(index: int) -> void:
	set_coin = true
	ready_to_save()
	match index:
		0:
			coin = "copper"
		1:
			coin = "iron"
		2:
			coin = "emerald"
		3:
			coin = "gold"
		4:
			coin = "diamond"
		5:
			coin = "netherite"
		6:
			coin = "amethyst"

func ready_to_save() -> void:
	if artist && inspo && set_name && set_coin:
		%confirmButton.disabled = false
	else:
		%confirmButton.disabled = true

#########################################################
func _on_confirm_button_pressed() -> void:
	var found_dupes = check_for_duplicates()
	if found_dupes != 0:
		dupe_exists(found_dupes)
	else:
		_save_complete_tack_set()

func dupe_exists(duplicates_found : int) -> void:
	var title = "Oops! Duplicates exists!"
	var message = "There are " + str(duplicates_found) + " items from this tack set that already exist in this pack. \nDo you still want to generate this tack set?"
	var no_label = "Go Back"
	var yes_label = "Generate the files"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func check_for_duplicates():
	var duplicate_exists : int
	if TackScripts.tack_dupe_check("saddle", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("bridle", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("blanket", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("leg_wraps", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("girth_strap", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("breast_collar", %tackText.text):
		duplicate_exists += 1
	return duplicate_exists

func _save_complete_tack_set() -> void:
	# DUPE SETS FOR ENG AND WESTERN
	if sad_western:
			TackScripts.saddle_save(%tackText.text, %artistText.text, %inspoText.text, coin, "western", adventure, %saddleSpinBox.value)

	if sad_english:
			TackScripts.saddle_save(%tackText.text, %artistText.text, %inspoText.text, coin, "english", adventure, %saddleSpinBox.value)

	if bri_western:
		if ErrorManager.is_error:
			return
		else:
			TackScripts.bridle_save(%tackText.text, %artistText.text, %inspoText.text, coin, "western", adventure, %bridleSpinBox.value)

	if bri_english:
		if ErrorManager.is_error:
			return
		else:
			TackScripts.bridle_save(%tackText.text, %artistText.text, %inspoText.text, coin, "english", adventure, %bridleSpinBox.value)

	if bla_western:
		if custom_rack:
			if ErrorManager.is_error:
				return
			else:
				TackScripts.girth_straps_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, %girthStrapSpinBox.value)
				TackScripts.blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, %blanketSpinBox.value)
		else:
			if ErrorManager.is_error:
				return
			else:
				TackScripts.colored_girth_strap_save(%Girth_Saddle, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure, %girthStrapSpinBox.value)
				TackScripts.colored_blanket_save(%West_Blanket5, %West_Saddle, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure, %blanketSpinBox.value)
	if bla_english:
		if custom_rack:
			if ErrorManager.is_error:
				return
			else:
				TackScripts.girth_straps_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, %girthStrapSpinBox.value)
				TackScripts.blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, %blanketSpinBox.value)
		else:
			if ErrorManager.is_error:
				return
			else:
				TackScripts.colored_girth_strap_save(%Girth_Saddle, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure, %girthStrapSpinBox.value)
				TackScripts.colored_blanket_save(%Eng_Blanket5, %Eng_Saddle, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure, %blanketSpinBox.value)
	if ErrorManager.is_error:
		return
	else:
		TackScripts.breast_collar_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, %breastCollarSpinBox.value)
		TackScripts.leg_wraps_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, %legWrapsSpinBox.value)
	if ErrorManager.is_error:
			return
	else:
		new_tack_saved.emit()

func on_popup_dupe_back() -> void:
	enable_interaction()

func on_popup_dupe_confirmed() -> void:
	_save_complete_tack_set()

func on_new_tack_saved() -> void:
	var title = "Complete!"
	var message = "Successfully added '" + %tackText.text + "' Tack Set to the pack folder. \nWhat do you want to do now?"
	var no_label = "Return to Menu"
	var yes_label = "Make Another"
	$popUP_Saved.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_saved_back() -> void:
	get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

func on_popup_saved_confirmed() -> void:
	enable_interaction()
	get_tree().reload_current_scene()

func are_you_sure() -> void:
	var title = "Wait a moment!"
	var message = "Are you sure you want to return to the Tack Menu?"
	var no_label = "Go Back"
	var yes_label = "Continue to Tack Menu"
	$popUPexit.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_exit_confirmed() -> void:
	get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

###########################################################

func _on_saddle_check_button_pressed() -> void:
	if sad_western:
		sad_western = false
		sad_english = true
		%WestSadLabel.add_theme_color_override("font_color", Color(0.49, 0.36, 0.22))
		%EngSadLabel.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133))
	else:
		sad_western = true
		sad_english = false
		%WestSadLabel.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133))
		%EngSadLabel.add_theme_color_override("font_color", Color(0.49, 0.36, 0.22))

func _on_bridle_check_button_pressed() -> void:
	if bri_western:
		bri_western = false
		bri_english = true
		%WestBriLabel.add_theme_color_override("font_color", Color(0.49, 0.36, 0.22))
		%EngBriLabel.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133))
	else:
		bri_western = true
		bri_english = false
		%WestBriLabel.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133))
		%EngBriLabel.add_theme_color_override("font_color", Color(0.49, 0.36, 0.22))

func _on_blanket_check_button_pressed() -> void:
	if bla_western:
		bla_western = false
		bla_english = true
		%WestBlaLabel.add_theme_color_override("font_color", Color(0.49, 0.36, 0.22))
		%EngBlaLabel.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133))
	else:
		bla_western = true
		bla_english = false
		%WestBlaLabel.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133))
		%EngBlaLabel.add_theme_color_override("font_color", Color(0.49, 0.36, 0.22))

func starting_coin_values() -> void:
	%saddleSpinBox.value = TackScripts.cost_saddle
	%bridleSpinBox.value = TackScripts.cost_bridle
	%blanketSpinBox.value = TackScripts.cost_blanket
	%legWrapsSpinBox.value = TackScripts.cost_leg_wraps
	%breastCollarSpinBox.value = TackScripts.cost_breast_collar
	%girthStrapSpinBox.value = TackScripts.cost_girth_straps
	

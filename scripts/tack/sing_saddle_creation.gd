extends Control

var artist : bool = false
var inspo : bool = false
var set_name : bool = false
var set_coin : bool = false

var sad_western : bool = true
var sad_english : bool = false
var adventure : bool = false

var coin : String

var file_name : String
var path : String
var file_opened : String

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
	%coinOptions.disabled = true
	%SaddleCheckButton.disabled = true
	%saddleSpinBox.editable = false
	%bridleSpinBox.editable = false

func enable_interaction() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true
	%armorCheckBox.disabled = false
	%coinOptions.disabled = false
	%SaddleCheckButton.disabled = false
	%saddleSpinBox.editable = true

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

func _on_armor_check_box_pressed() -> void:
	if adventure:
		adventure = false
		%armorLabel.text = "No"
	else:
		adventure = true
		%armorLabel.text = "Yes"

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
	if TackScripts.tack_dupe_check("saddle", %tackText.text):
		dupe_exists()
	else:
		_save_tack()

func dupe_exists() -> void:
	var title = "This saddle already exists!"
	var message = "There already exists a saddle named '" + %tackText.text + "'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Overwrite it"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func _save_tack() -> void:
	# DUPE SETS FOR ENG AND WESTERN
	if sad_western:
			TackScripts.saddle_save(%tackText.text, %artistText.text, %inspoText.text, coin, "western", adventure, %saddleSpinBox.value)
	if sad_english:
			TackScripts.saddle_save(%tackText.text, %artistText.text, %inspoText.text, coin, "english", adventure, %saddleSpinBox.value)
	
	if ErrorManager.is_error:
			return
	else:
		new_tack_saved.emit()

func on_popup_dupe_back() -> void:
	enable_interaction()

func on_popup_dupe_confirmed() -> void:
	_save_tack()

func on_new_tack_saved() -> void:
	var title = "Complete!"
	var message = "Successfully added '" + %tackText.text + "' to the pack folder. \nWhat do you want to do now?"
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

func starting_coin_values() -> void:
	%saddleSpinBox.value = TackScripts.cost_saddle


func _on_file_dialog_file_selected(path: String) -> void:
	var save_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "saddle")
	if !GlobalScripts.check_file_exists(save_path):
		GlobalScripts.make_folder(save_path)
	else:
		pass
	if file_opened == "icon":
		save_path = save_path + "/" + GlobalScripts.text_clean(%tackText.text) + "_icon.png"
	if file_opened == "horse":
		save_path = save_path + "/" + GlobalScripts.text_clean(%tackText.text) + "_legacy.png"
	if file_opened == "rack":
		save_path = save_path + "/" + GlobalScripts.text_clean(%tackText.text) + "_icon.png"
	var image = Image.load_from_file(path)
	image.save_png(save_path)
	GlobalScripts.report("Saved user selected image: " + path + "  to the file location: " + save_path)


func _on_iconbutton_button_pressed() -> void:
	print("PRESSED!")
	file_opened = "icon"
	$FileDialog.visible = true
	$FileDialog.title = "Select an Icon Texture"

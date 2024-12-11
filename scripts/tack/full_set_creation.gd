extends Control

var artist : bool = false
var inspo : bool = false
var set_name : bool = false
var set_armor : bool = false
var set_coin : bool = false

var western : bool = false
var english : bool = false
var both_sets : bool = false
var adventure : bool = false

var custom_rack : bool = false
var red : float = 255.0
var green : float = 255.0
var blue : float = 255.0
var coin : String
var armor : String

var arpb : bool = true
var pb : bool = true
var ar : bool = true
var sb : bool = true
var hal : bool = true

var file_name : String
var path : String

var west_name : String
var eng_name : String

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
	%westCheckBox.disabled = true
	%engCheckBox.disabled = true
	%armorCheckBox.disabled = true
	%custCheckBox.disabled = true
	%redSpinBox.editable = false
	%greenSpinBox.editable = false
	%blueSpinBox.editable = false
	%armorOptions.disabled = true
	%coinOptions.disabled = true
	%arpbCheckBox.disabled = true
	%pbCheckBox.disabled = true
	%arCheckBox.disabled = true
	%sbCheckBox.disabled = true
	%halCheckBox.disabled = true

func enable_interaction() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true
	%westCheckBox.disabled = false
	%engCheckBox.disabled = false
	%armorCheckBox.disabled = false
	%custCheckBox.disabled = false
	%redSpinBox.editable = true
	%greenSpinBox.editable = true
	%blueSpinBox.editable = true
	%armorOptions.disabled = false
	%coinOptions.disabled = false
	%arpbCheckBox.disabled = false
	%pbCheckBox.disabled = false
	%arCheckBox.disabled = false
	%sbCheckBox.disabled = false
	%halCheckBox.disabled = false


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
	if both_sets:
		%inGameLabel.text = text + " English Bridle"
		%dataLabel.text = GlobalScripts.text_clean(text) + "_english_bridle"
	else:
		%inGameLabel.text = text + " Bridle"
		%dataLabel.text = GlobalScripts.text_clean(text) + "_bridle"

func _on_west_check_box_pressed() -> void:
	if western:
		western = false
		if both_sets:
			both_sets = false
			on_both_sets()
		else:
			pass
	else:
		western = true
		if english:
			both_sets = true
			on_both_sets()
		else:
			pass
	ready_to_save()

func _on_eng_check_box_pressed() -> void:
	if english:
		english = false
		if both_sets:
			both_sets = false
			on_both_sets()
		else:
			pass
	else:
		english = true
		if western:
			both_sets = true
			on_both_sets()
		else:
			pass
	ready_to_save()

func on_both_sets() -> void:
	if both_sets:
		update_name_previews()
		%AlertLabel.text = "Both Tack Models have been selected - A full set of 'English' and 'Western' set will be generated."
	else:
		update_name_previews()
		%AlertLabel.text = ""

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

func _on_armor_options_item_selected(index: int) -> void:
	set_armor = true
	ready_to_save()
	match index:
		0:
			armor = "cloth"
		1:
			armor = "iron"
		2:
			armor = "gold"
		3:
			armor = "diamond"
		4:
			armor = "amethyst"

func _on_arpb_check_box_pressed() -> void:
	if arpb:
		arpb = false
		%arpbLabel.text = "No"
	else:
		arpb = true
		%arpbLabel.text = "Yes"

func _on_pb_check_box_pressed() -> void:
	if pb:
		pb = false
		%pbLabel.text = "No"
	else:
		pb = true
		%pbLabel.text = "Yes"

func _on_ar_check_box_pressed() -> void:
	if ar:
		ar = false
		%arLabel.text = "No"
		%armorOptions.disabled = true
	else:
		ar = true
		%arLabel.text = "Yes"
		%armorOptions.disabled = false
	ready_to_save()

func _on_sb_check_box_pressed() -> void:
	if sb:
		sb = false
		%sbLabel.text = "No"
	else:
		sb = true
		%sbLabel.text = "Yes"

func _on_hal_check_box_pressed() -> void:
	if hal:
		hal = false
		%halLabel.text = "No"
	else:
		hal = true
		%halLabel.text = "Yes"

func ready_to_save() -> void:
	#print("run ready_to_save")
	if artist && inspo && set_name && set_coin:
		if western or english:
			if !ar or set_armor:
				%confirmButton.disabled = false
			else:
				%confirmButton.disabled = true
		else:
			%confirmButton.disabled = true
	else:
		%confirmButton.disabled = true

#########################################################
func _on_confirm_button_pressed() -> void:
	var title = "About to Save Tack..."
	var message = "The generated tack will overwrite any existing tack of the same names... \nDo you want to generate this tack set?"
	var no_label = "NO, Go Back"
	var yes_label = "YES, Generate Tack"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()
	
func _save_complete_tack_set() -> void:
	# DUPE SETS FOR ENG AND WESTERN
	if both_sets:
		eng_name = %tackText.text + " English"
		west_name = %tackText.text + " Western"
		western_tack()
		english_tack()
	else:
		if western:
			west_name = %tackText.text
			western_tack()
		if english:
			eng_name = %tackText.text
			english_tack()
		
	#CUSTOM RACK TEXTURES
	if custom_rack:
		if pb:
			TackScripts.pasture_blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin)
		if arpb:
			TackScripts.ar_pasture_blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin)
	else:
		if pb:
			TackScripts.colored_pasture_blanket_save(%Past_5Long, %Past_3Short, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue)
		if arpb:
			TackScripts.colored_ar_pasture_blanket_save(%ArmPast_5Long, %ArmPast_3Short, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue)
	
	#ONE OFFS & OPTIONAL
	if ar: # armor
		TackScripts.armor_save(%tackText.text, %artistText.text, %inspoText.text, coin, armor)
	
	if sb: #saddle bag
		TackScripts.saddle_bag_save(%tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue)
	
	if hal: #halter
		TackScripts.halter_save(%tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure)
	
	new_tack_saved.emit()

func western_tack() -> void:
	TackScripts.saddle_save(west_name, %artistText.text, %inspoText.text, coin, "western", adventure)
	TackScripts.bridle_save(west_name, %artistText.text, %inspoText.text, coin, "western", adventure)
	TackScripts.breast_collar_save(west_name, %artistText.text, %inspoText.text, coin, adventure)
	TackScripts.leg_wraps_save(west_name, %artistText.text, %inspoText.text, coin, adventure)
	
	if custom_rack:
		TackScripts.girth_straps_save(west_name, %artistText.text, %inspoText.text, coin, adventure)
		TackScripts.blanket_save(west_name, %artistText.text, %inspoText.text, coin, adventure)
	else:
		TackScripts.colored_girth_strap_save(%Girth_Saddle, west_name, %artistText.text, %inspoText.text, coin, red, green, blue, adventure)
		TackScripts.colored_blanket_save(%West_Blanket5, %West_Saddle, west_name, %artistText.text, %inspoText.text, coin, red, green, blue, adventure)

func english_tack() -> void:
	TackScripts.saddle_save(eng_name, %artistText.text, %inspoText.text, coin, "english", adventure)
	TackScripts.bridle_save(eng_name, %artistText.text, %inspoText.text, coin, "english", adventure)
	TackScripts.breast_collar_save(eng_name, %artistText.text, %inspoText.text, coin, adventure)
	TackScripts.leg_wraps_save(eng_name, %artistText.text, %inspoText.text, coin, adventure)
	
	if custom_rack:
		TackScripts.girth_straps_save(eng_name, %artistText.text, %inspoText.text, coin, adventure)
		TackScripts.blanket_save(eng_name, %artistText.text, %inspoText.text, coin, adventure)
	else:
		TackScripts.colored_girth_strap_save(%Girth_Saddle, eng_name, %artistText.text, %inspoText.text, coin, red, green, blue, adventure)
		TackScripts.colored_blanket_save(%Eng_Blanket5, %Eng_Saddle, eng_name, %artistText.text, %inspoText.text, coin, red, green, blue, adventure)

func on_popup_dupe_back() -> void:
	enable_interaction()

func on_popup_dupe_confirmed() -> void:
	_save_complete_tack_set()

func on_new_tack_saved() -> void:
	var title = "Complete!"
	var message = "Successfully added '" + %tackText.text + "' Tack Set to the pack folder. \nWhat do you want to do now?"
	var no_label = "Go Back"
	var yes_label = "Start A New Set"
	$popUP_Saved.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_saved_back() -> void:
	enable_interaction()

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

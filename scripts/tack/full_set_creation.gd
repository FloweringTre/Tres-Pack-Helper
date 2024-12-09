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

signal new_tack_saved

func _ready() -> void:
	ErrorManager.error_alert.connect(on_error)
	$errorMessage.error_continue.connect(on_error_continue)
	new_tack_saved.connect(on_new_tack_saved)
	$popUP_Saved.deny.connect(on_popup_saved_back)
	$popUP_Saved.confirm.connect(on_popup_saved_confirmed)
	$popUP2_Dupe.deny.connect(on_popup_dupe_back)
	$popUP2_Dupe.confirm.connect(on_popup_dupe_confirmed)
	TackScripts.blanket_saved.connect(on_new_tack_saved)

func on_error() -> void:
	%confirmButton.disabled = true
	%backButton.disabled = true
	%artistText.editable = false
	%inspoText.editable = false
	%tackText.editable = false

func on_error_continue() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

func _on_artist_text_text_changed() -> void:
	if %artistText.text != "":
		artist = true
	else:
		artist = false
	ready_to_save()

func _on_inspo_text_text_changed() -> void:
	if %inspoText.text != "":
		inspo = true
	else:
		inspo = false

func _on_tack_text_text_changed() -> void:
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
	TackScripts.blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure)

func tack_exists() -> void:
	var title = "This tack already exists!"
	var message = "There already exists a tack set named '" + %tackText.text + "'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Overwrite it"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	%confirmButton.disabled = true
	%backButton.disabled = true
	%artistText.editable = false
	%inspoText.editable = false
	%tackText.editable = false

func on_popup_dupe_back() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true

func on_popup_dupe_confirmed() -> void:
	pass

func on_new_tack_saved() -> void:
	var title = "Complete!"
	var message = "Successfully added '" + %tackText.text + "' Tack Set to the pack folder. \nWhat do you want to do now?"
	var no_label = "Go Back"
	var yes_label = "Start A New Set"
	$popUP_Saved.pop_yesNo(title, message, no_label, yes_label)
	%confirmButton.disabled = true
	%backButton.disabled = true
	%artistText.editable = false
	%inspoText.editable = false
	%tackText.editable = false

func on_popup_saved_back() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true

func on_popup_saved_confirmed() -> void:
	get_tree().reload_current_scene()

###########################################################

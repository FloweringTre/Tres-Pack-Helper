extends Control

@onready var location_text: TextEdit = $NinePatchRect/VBoxContainer/Hbox/locationText
@onready var folder_nametext: TextEdit = $NinePatchRect/VBoxContainer/Hbox2/folderNametext
@onready var file_dialog: FileDialog = $FileDialog

var old_pack : bool
signal setup_done
var root_changed : bool
var folder_changed : bool
var directory : String

func _ready() -> void:
	if GlobalScripts.root != "":
		location_text.text = GlobalScripts.root
		root_changed = true
		old_pack = true
		on_done()
	else:
		location_text.text = GlobalScripts.directory_root
	if GlobalScripts.folder != "":
		folder_nametext.text = GlobalScripts.folder
		old_pack = true
		folder_changed = true
		on_done()
	setup_done.connect(on_done)
	ErrorManager.error_alert.connect(on_error)
	%confirmButton.disabled = true
	%pathOpenButton.button_pressed.connect(on_path_button_pressed)
	%coatsButton.button_pressed.connect(on_coats_selected)
	%tackButton.button_pressed.connect(on_tack_selected)
	$errorMessage.error_continue.connect(on_error_continue)
	%nameCheck.button_pressed.connect(on_name_check)
	%animButton2.set_disabled()
	$popUP.deny.connect(on_popup_back)
	$popUP.confirm.connect(on_popup_confirmed)

func _on_confirm_button_pressed() -> void:
	var Root = location_text.text
	var folder = folder_nametext.text
	Root = GlobalScripts.path_clean(Root)
	folder = GlobalScripts.path_clean(folder)
	GlobalScripts.root = Root
	GlobalScripts.folder = folder
	directory = GlobalScripts.join_paths(Root, folder)
	
	if GlobalScripts.check_folder(directory):
		folder_exists()
	else:
		GlobalScripts.new_pack_setup(directory)
		old_pack = false
		setup_done.emit()

func on_done() -> void:
	if ErrorManager.is_error:
		pass
	else:
		$NinePatchRect/VBoxContainer/Stage1BoxContainer.visible = false
		%confirmButton.visible = false
		$NinePatchRect/VBoxContainer/Stage2BoxContainer.visible = true
		$NinePatchRect/VBoxContainer/HelperLabel.visible = false
		$checkPathLOCA.visible = false
		$checkPathFOLD.visible = false
		%nameCheck.set_disabled()
		%pathOpenButton.set_disabled()
		location_text.editable = false
		folder_nametext.editable = false
		if old_pack:
			$NinePatchRect/VBoxContainer/Stage2BoxContainer/Stage2Text.text  = \
			GlobalScripts.folder + " folder has been opened!"
		else:
			$NinePatchRect/VBoxContainer/Stage2BoxContainer/Stage2Text.text  = \
			GlobalScripts.folder + " folder has been generated!"

func on_coats_selected() -> void:
	get_tree().change_scene_to_file("res://scene/coatGUI.tscn")

func on_tack_selected() -> void:
	get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

func on_animation_selected() -> void:
	pass

func _on_location_text_text_changed() -> void:
	$checkPathLOCA.awaiting_check()
	root_changed = false
	%confirmButton.disabled = true 

func _on_folder_nametext_text_changed() -> void:
	$checkPathFOLD.awaiting_check()
	folder_changed = false
	%confirmButton.disabled = true 

func on_error() -> void:
	root_changed = false
	%confirmButton.disabled = true
	%backButton.disabled = true

func on_error_continue() -> void:
	$checkPathFOLD.set_check(false)
	$checkPathLOCA.set_check(false)
	root_changed = false
	folder_changed = false
	%confirmButton.disabled = true
	%backButton.disabled = false
	
func _on_back_button_pressed() -> void:
	get_tree().quit()

func on_path_button_pressed() -> void:
	location_text.text = GlobalScripts.path_clean(location_text.text)
	if GlobalScripts.check_folder(location_text.text):
		$checkPathLOCA.set_check(true)
		root_changed = true
		if folder_changed == true:
			%confirmButton.disabled = false
		else:
			pass
	else:
		$checkPathLOCA.set_check(false)
		root_changed = false

func on_name_check() -> void:
	if folder_nametext.text == "":
		$checkPathFOLD.set_check(false)
		folder_changed = false
	else:
		folder_nametext.text = GlobalScripts.text_clean(folder_nametext.text)
		$checkPathFOLD.set_check(true)
		folder_changed = true
		if root_changed == true:
			%confirmButton.disabled = false
		else:
			pass

func folder_exists() -> void:
	var title = "This folder already exists!"
	var message = "There already exists a pack folder named '" + folder_nametext.text + "'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Open it"
	$popUP.pop_yesNo(title, message, no_label, yes_label)
	%confirmButton.disabled = true
	%backButton.disabled = true
	%nameCheck.set_disabled()
	%pathOpenButton.set_disabled()
	location_text.editable = false
	folder_nametext.editable = false

func on_popup_back() -> void:
	%confirmButton.disabled = false
	%backButton.disabled = false
	%nameCheck.reenable_button()
	%pathOpenButton.reenable_button()
	location_text.editable = true
	folder_nametext.editable = true

func on_popup_confirmed() -> void:
	var opened_dir= DirAccess.open(directory)
	GlobalScripts.old_pack_setup(directory)
	old_pack = true
	setup_done.emit()

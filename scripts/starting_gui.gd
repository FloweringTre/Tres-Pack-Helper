extends Control

@onready var location_text: TextEdit = $NinePatchRect/VBoxContainer/Hbox/locationText
@onready var folder_nametext: TextEdit = $NinePatchRect/VBoxContainer/Hbox2/folderNametext

var old_pack : bool
signal setup_done
var root_changed : bool
var folder_changed : bool

func _ready() -> void:
	if GlobalScripts.root != "":
		location_text.text = GlobalScripts.root
		root_changed = true
		old_pack = true
		on_done()
	if GlobalScripts.folder != "":
		folder_nametext.text = GlobalScripts.folder
		old_pack = true
		folder_changed = true
		on_done()
	setup_done.connect(on_done)
	ErrorManager.error_alert.connect(on_error)
	%confirmButton.disabled = true
	%coatsButton.button_pressed.connect(on_coats_selected)
	%tackButton.button_pressed.connect(on_tack_selected)
	$errorMessage.error_continue.connect(on_error_continue)


func _on_confirm_button_pressed() -> void:
	var Root = location_text.text
	var folder = folder_nametext.text
	Root = GlobalScripts.path_clean(Root)
	folder = GlobalScripts.path_clean(folder)
	GlobalScripts.root = Root
	GlobalScripts.folder = folder
	var directory = GlobalScripts.join_paths(Root, folder)
	var opened_dir= DirAccess.open(directory)
	
	if opened_dir:
		GlobalScripts.old_pack_setup(directory)
		old_pack = true
		setup_done.emit()
	else:
		GlobalScripts.new_pack_setup(directory)
		old_pack = false
		setup_done.emit()
	

func on_done() -> void:
	if ErrorManager.is_error:
		pass
	else:
		$NinePatchRect/VBoxContainer/HelperLabel3.visible = false
		$NinePatchRect/confirmButton.visible = false
		$NinePatchRect/VBoxContainer/Stage2BoxContainer.visible = true
		if old_pack:
			$NinePatchRect/VBoxContainer/Stage2BoxContainer/Stage2Text.text  = \
			GlobalScripts.folder + " folder has been opened!"
		else:
			$NinePatchRect/VBoxContainer/Stage2BoxContainer/Stage2Text.text  = \
			GlobalScripts.folder + " folder has been generated!"


func on_coats_selected() -> void:
	get_tree().change_scene_to_file("res://scene/coatGUI.tscn")

func on_tack_selected() -> void:
	pass


func _on_location_text_text_changed() -> void:
	if location_text.text != "":
		root_changed = true
		if folder_changed == true:
			%confirmButton.disabled = false
		else:
			pass
	else:
		root_changed = false
		%confirmButton.disabled = true 


func _on_folder_nametext_text_changed() -> void:
	if folder_nametext.text != "":
		folder_changed = true
		if root_changed == true:
			%confirmButton.disabled = false
		else:
			pass
	else:
		folder_changed = false
		%confirmButton.disabled = true 

func on_error() -> void:
	root_changed = false
	%confirmButton.disabled = true
	%backButton.disabled = true

func on_error_continue() -> void:
	root_changed = false
	%confirmButton.disabled = true
	%backButton.disabled = false
	
func _on_back_button_pressed() -> void:
	get_tree().quit()

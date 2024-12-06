extends Control

@onready var location_text: TextEdit = $NinePatchRect/VBoxContainer/Hbox/locationText
@onready var folder_nametext: TextEdit = $NinePatchRect/VBoxContainer/Hbox2/folderNametext

func _on_confirm_button_pressed() -> void:
	var Root = location_text.text
	var directory_Root = Root.replace("\\", "/")
	var folder = folder_nametext.text
	var directory = directory_Root + "/" + folder + "/"
	var opened_dir= DirAccess.open(directory)
	
	if opened_dir:
		print("I opened ", folder, " located at", directory)
	else:
		var new_dir = DirAccess.make_dir_absolute(directory)
		print("I made a new folder named ", folder, " located at", directory)
	
	

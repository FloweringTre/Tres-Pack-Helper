extends Control

@onready var location_text: TextEdit = $NinePatchRect/VBoxContainer/Hbox/locationText
@onready var folder_nametext: TextEdit = $NinePatchRect/VBoxContainer/Hbox2/folderNametext

func _on_confirm_button_pressed() -> void:
	var Root = location_text.text
	var directory_Root = Root.replace("\\", "/")
	if directory_Root.ends_with("/"):
		directory_Root.erase(-1)	
	var folder = folder_nametext.text
	folder = folder.replace("\\", "/")
	if folder.ends_with("/"):
		folder.erase(-1)
	if folder.begins_with("/"):
		folder.erase(0)
	
	var directory = directory_Root + "/" + folder + "/"
	var opened_dir= DirAccess.open(directory)
	
	if opened_dir:
		print("I opened ", folder, " located at", directory)
		GlobalTrackingValues.directory_root = directory
	else:
		var new_dir = DirAccess.make_dir_absolute(directory)
		print("I made a new folder named ", folder, " located at", directory)
		GlobalTrackingValues.directory_root = directory
	
	

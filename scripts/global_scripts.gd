extends Node

var directory_root : String = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
var root : String = ""
var folder: String = ""
var jsons_root : String
var textures_root : String
var report_file_path : String
var instructions_file_path : String

enum TackTypes {
	SaddleBlanket, 
	BreastCollar, 
	Bridle, 
	GirthStrap, 
	Halter, 
	HorseArmor,
	LegWraps,
	PastureBlanket,
	Saddle,
	SaddleBag
}

func path_clean(path : String): #prepares file paths to proper GDscript format
	var cleaned_path : String
	cleaned_path = path.replace("\\", "/")
	if cleaned_path.ends_with("/"):
		cleaned_path.erase(-1)
	if cleaned_path.begins_with("/"):
		cleaned_path.erase(0)
	return cleaned_path

func text_clean(text : String): #takes strings and makes them acceptable for java
	var temp_n = "" 
	text = text.to_lower()
	for char in text:
		if (char >= "a" and char <= "z") or (char >= "0" and char <= "9") or char == "_":
			temp_n += char
		if char == " " or char == "-":
			temp_n += "_"
		else:
			pass
	return temp_n

func join_paths(root_path : String, folder : String): #joins two values to a correct file path
	var new_path : String
	new_path = root_path + "/" + folder
	return new_path

func new_pack_setup(directory : String) -> void: #Build a new pack
	directory_root = directory
	report_file_path = join_paths(directory_root, "TRE.S_PACK_HELPER_REPORT.txt")
	instructions_file_path = join_paths(directory_root, "INSTRUCTIONS.txt")
	jsons_root = join_paths(directory_root, "jsons")
	textures_root = join_paths(directory_root, "textures")
	DirAccess.make_dir_absolute(directory_root)
	setup_report()
	set_up_instructions()
	make_folder(jsons_root)
	make_folder(textures_root)
	report("I finished setting up a new main pack folder at " + directory_root)

func old_pack_setup(directory : String) -> void: #Open an existing pack
	directory_root = directory
	report_file_path = join_paths(directory_root, "TRE.S_PACK_HELPER_REPORT.txt")
	instructions_file_path = join_paths(directory_root, "INSTRUCTIONS.txt")
	jsons_root = join_paths(directory_root, "jsons")
	textures_root = join_paths(directory_root, "textures")
	setup_report()
	set_up_instructions()
	if !check_folder(jsons_root):
		make_folder(jsons_root)
	if !check_folder(textures_root):
		make_folder(textures_root)
	report("I opened the following directory: " + directory)

func check_folder(path : String): #does a folder exist
	if DirAccess.open(path):
		return true
	else:
		return false

func check_file_exists(path : String): #is there already a file here?
	if FileAccess.file_exists(path):
		return true
	else:
		return false

func make_folder(path : String) -> void: #make a new folder and log it
	DirAccess.make_dir_absolute(path)
	report("I made a new folder at " + path)

func setup_coats() -> void:
	var temp_j = join_paths(jsons_root, "coats")
	var temp_t = join_paths(textures_root, "coats")
	var temp_l = join_paths(temp_t, "legacy")
	if !check_folder(temp_j):
		make_folder(temp_j)
	if !check_folder(temp_t):
		make_folder(temp_t)
	if !check_folder(temp_l):
		make_folder(temp_l)

func setup_main_tack() -> void:
	var temp_j = join_paths(jsons_root, "tack")
	var temp_t = join_paths(textures_root, "tack")
	if !check_folder(temp_j):
		make_folder(temp_j)
	if !check_folder(temp_t):
		make_folder(temp_t)

func setup_tack(tack_type : int):
	setup_main_tack()
	var temp_j = join_paths(jsons_root, "tack")
	var temp_t = join_paths(textures_root, "tack")
	var tack_item : String
	match tack_type:
		0: #blanket
			tack_item = "blanket"
		1: #breast collar
			tack_item = "breast_collar"
		2: #bridle
			tack_item = "bridle"
		3: #girth strap
			tack_item = "girth_strap"
		4: #halter
			tack_item = "halter"
		5: #horse armor
			tack_item = "horse_armor"
		6: #leg wraps
			tack_item = "leg_wraps"
		7: #pasture blanket
			tack_item = "pasture_blanket"
		8: #saddle
			tack_item = "saddle"
		9: #saddlebag
			tack_item = "saddle_bag"
	var tack_j = join_paths(temp_j, tack_item)
	var tack_t = join_paths(temp_t, tack_item)
	if !check_folder(tack_j):
		make_folder(tack_j)
	if !check_folder(tack_t):
		make_folder(tack_t)
	
func setup_report() -> void:
	if ErrorManager.is_error:
		return
	else:
		if check_file_exists(report_file_path):
			report("I opened back up this pack folder")
		else:
			var file = FileAccess.open(report_file_path, FileAccess.WRITE_READ)
			if !file:
				ErrorManager.is_error = true
				ErrorManager.error_print("Unable to set up the report document - check the file path location." )
				return
			else:
				file.store_string("This document will log all creations made by Tre's Pack Helper application.\n\n" )
				file.close()
	report("I set up the report document.")

func report(reporting_text : String):
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(report_file_path, FileAccess.READ_WRITE)
		var report_string = Time.get_datetime_string_from_system(false, true) + " -- " + reporting_text + "\n"
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("Unable to write a report. Please check to see if the folder pathway still exists." )
			return
		else:
			file.seek_end()
			file.store_string(report_string)
			file.close()

func set_up_instructions() -> void:
	if ErrorManager.is_error:
		return
	else:
		if check_file_exists(instructions_file_path):
			var date_time = Time.get_datetime_string_from_system(false, true)
			var file = FileAccess.open(instructions_file_path, FileAccess.READ_WRITE)
			file.seek_end()
			file.store_string("\n\n~~~~~~~~~ Pack has been reopened for editing at " + date_time + " ~~~~~~~~~\n")
			file.close()
		else:
			var file = FileAccess.open(instructions_file_path, FileAccess.WRITE_READ)
			if !file:
				ErrorManager.is_error = true
				ErrorManager.error_print("Unable to set up the instructions document - check the file path location.")
				return
			else:
				file.store_string("This document will tell you the names of each texture to add and where to add them.\n \
	Please understand, your pack will not function if the textures are not correctly named or placed in the wrong folders.\n\n" )
				file.close()
				report("I set up the INSTRUCTIONS.txt document")

func instructions(item : String, texture_name : String, path : String):
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(instructions_file_path, FileAccess.READ_WRITE)
		var string_1 = "\nADD NEW " + item.to_upper() + "\n"# ADD NEW COAT
		var string_2 = "~~Name the Texture: " + texture_name + ".png" + "\n"# ~~Name Texture: kiwi_wonder_pony.png
		var string_3 = "~~Save Texture in: " + path + "\n" # ~~Save to: folder/path/way
		var instruction_string = string_1 + string_2 + string_3
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("Unable to save instructions. Please check to see if the folder pathway still exists." )
			return
		else:
			file.seek_end()
			file.store_string(instruction_string)
			file.close()

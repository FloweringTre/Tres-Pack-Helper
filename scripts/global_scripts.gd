extends Node

var directory_root : String
var root : String = ""
var folder: String = ""
var jsons_root : String
var textures_root : String
var report_file_path : String


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

func path_clean(path : String):
	var cleaned_path : String
	cleaned_path = path.replace("\\", "/")
	if cleaned_path.ends_with("/"):
		cleaned_path.erase(-1)
	if cleaned_path.begins_with("/"):
		cleaned_path.erase(0)
	return cleaned_path

func join_paths(root_path : String, folder : String):
	var new_path : String
	new_path = root_path + "/" + folder
	return new_path

func new_pack_setup(directory : String):
	directory_root = directory
	report_file_path = join_paths(directory_root, "TRE.S_PACK_HELPER_REPORT.txt")
	jsons_root = join_paths(directory_root, "jsons")
	textures_root = join_paths(directory_root, "textures")
	DirAccess.make_dir_absolute(directory_root)
	setup_report()
	report("I set up a new main pack folder at " + directory_root)
	make_folder(jsons_root)
	make_folder(textures_root)

func old_pack_setup(directory : String):
	print("I opened the following directory: ", directory)
	directory_root = directory
	report_file_path = join_paths(directory_root, "TRE.S_PACK_HELPER_REPORT.json")
	jsons_root = join_paths(directory_root, "jsons/")
	textures_root = join_paths(directory_root, "textures/")
	if !check_folder(jsons_root):
		make_folder(jsons_root)
		print("I made a new folder at ", jsons_root)
	if !check_folder(textures_root):
		make_folder(textures_root)
		print("I made a new folder at ", textures_root)
	print("I completed setting up the directory roots")

func check_folder(path : String):
	if DirAccess.open(path):
		return true
	else:
		return false

func make_folder(path : String) -> void:
	DirAccess.make_dir_absolute(path)
	report("I made a new folder at " + path)

func setup_coats() -> void:
	var temp_j = join_paths(jsons_root, "coats")
	var temp_t = join_paths(textures_root, "coats/legacy")
	if !check_folder(temp_j):
		make_folder(temp_j)
	if !check_folder(temp_t):
		make_folder(temp_t)

func setup_main_tack() -> void:
	var temp_j = join_paths(jsons_root, "tack")
	var temp_t = join_paths(textures_root, "tack")
	if !check_folder(temp_j):
		make_folder(temp_j)
	if !check_folder(temp_t):
		make_folder(temp_t)

func setup_tack_type(tack_type : int):
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
		var file = FileAccess.open(report_file_path, FileAccess.WRITE)
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("File Location listed is not a real location. Make sure it includes the \
			Drive letter ie: C:\\" )
			return
		else:
			file.store_string("This document will log all creations made by Tre's Pack Helper application.\n\n" )
			file.close()

func report(reporting_text : String):
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(report_file_path, FileAccess.READ_WRITE)
		var report_string = Time.get_datetime_string_from_system(false, true) + " -- " + reporting_text + "\n"
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("File Location listed is not a real location. Make sure it includes the \
			Drive letter ie: C:\\" )
			return
		else:
			file.seek_end()
			file.store_string(report_string)
			file.close()

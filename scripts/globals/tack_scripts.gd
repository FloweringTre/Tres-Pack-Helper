extends Node

var cost_saddle : int = 16
var cost_bridle : int = 5
var cost_blanket : int = 5
var cost_halter : int = 4
var cost_leg_wraps : int = 4
var cost_breast_collar : int = 10
var cost_armor : int = 64
var cost_saddle_bag : int = 8
var cost_girth_straps : int = 3
var cost_pasture_blanket : int = 16
var cost_ar_pasture_blanket : int = 32

var json_dir = GlobalScripts.join_paths(GlobalScripts.jsons_root, "tack")
var text_dir = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")

signal blanket_saved

func blanket_save(item : String, artist : String, inspo : String, coin : String, red : int, green : int , blue : int, adv: bool, amount : int = cost_blanket) -> void:
	var type = "blanket"
	item = item + " Blanket"
	var java_name = GlobalScripts.text_clean(item)
	var file_name = java_name + ".json"
	var path = GlobalScripts.join_paths(json_dir, type)
	path = GlobalScripts.join_paths(path, file_name)
	
	var root = type + "/"
	var icon = java_name + "_icon.png"
	var leg_blanket = java_name + "_legacy.png"
	var rack_saddle = "rack_saddle_" + java_name + ".png"
	var rack_5 = "rack_blanket_5_" + java_name + ".png"
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		var display = {
			"credits" = artist,
			"inspiration" = inspo,
			"name" = item
		}
		
		var cost = {
			"coin" = coin,
			"amount" = amount
		}
		
		var legacy = {
			"blanket" = root + leg_blanket
		}
		var data = {
			"color" = [red, green, blue],
			"can_wear_armor" = adv
		}
		var rack = {
			"saddle" = root + rack_saddle,
			"blanket_5" = root + rack_5
		}
		
		var meta = {
			"name" = java_name,
			"icon" = root + icon,
			"type" = type,
			"data" = data,
			"horse" = legacy,
			"rack" = rack
		}
		
		var save_file = display + cost + meta
		
		var string_1 = JSON.stringify(save_file)
		
		file.store_string(string_1)
		file.close()
		
		var textures = "~~~Icon Texture: " + icon + "\n" + "#~~~Horse Texture: " + leg_blanket\
		 + "\n" + "~~~Saddle Rack Texture: " + rack_saddle + "\n" + "~~~5 Blanket Rack Texture: " + rack_5 + "\n"
		var text_path = GlobalScripts.join_paths(text_dir, type)
		
		GlobalScripts.instructions_tack("Blanket", item, textures, text_path)
		GlobalScripts.report("I saved the new blanket, '" + item + "', to " + path)
		blanket_saved.emit()
	
	else:
		ErrorManager.error_print("I couldn't save the new tack set. The ./json/tack/ folder wouldn't open. Check to see if it exists.")

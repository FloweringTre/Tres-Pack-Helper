extends Node

var current_error : String
var is_error : bool

signal error_alert

func error_print(error_text : String):
	current_error = error_text
	print("ALERT!")
	error_alert.emit()

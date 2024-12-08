extends NinePatchRect

signal confirm
signal deny
signal go_on



func _on_continue_button_pressed() -> void:
	go_on.emit()

func _on_confirm_button_pressed() -> void:
	confirm.emit()

func _on_back_button_pressed() -> void:
	deny.emit()

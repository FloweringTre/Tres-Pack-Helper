extends NinePatchRect

signal confirm
signal deny
signal go_on
signal opened

func _ready() -> void:
	$".".visible = false

func _on_continue_button_pressed() -> void:
	go_on.emit()
	$".".visible = false

func _on_confirm_button_pressed() -> void:
	confirm.emit()
	$".".visible = false

func _on_back_button_pressed() -> void:
	deny.emit()
	$".".visible = false

func pop_continue(title : String, message : String, continue_message : String = "Lets try that again...") -> void:
	$".".visible = true
	$yesOrNo.visible = false
	$yesOrNoLabel.visible = false
	$continue.visible = true
	%titleLabel.text = title
	%popUpText.text = message
	%continueLabel.text = continue_message
	opened.emit()

func pop_yesNo(title : String, message : String, no_label : String = "Back", yes_label : String = "Continue") -> void:
	$".".visible = true
	$continue.visible = false
	$yesOrNo.visible = true
	$yesOrNoLabel.visible = true
	%titleLabel.text = title
	%popUpText.text = message
	%noLabel.text = no_label
	%yesLabel.text = yes_label
	opened.emit()
	

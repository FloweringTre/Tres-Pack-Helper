extends Control

func _ready() -> void:
	$NinePatchRect.visible = false
	ErrorManager.error_alert.connect(on_error)
	ErrorManager.error_passed.connect(on_error_passed)


func _on_texture_button_pressed() -> void:
	$AnimationPlayer.play("open")


func _on_back_button_pressed() -> void:
	$AnimationPlayer.play("exit")

func on_error() -> void:
	$TextureButton.disabled = true
	%backButton.disabled = true

func on_error_passed() -> void:
	$TextureButton.disabled = false
	%backButton.disabled = false

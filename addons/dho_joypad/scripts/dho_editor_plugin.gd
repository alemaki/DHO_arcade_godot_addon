@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "DhoJoypad"
const AUTOLOAD_PATH: String = "res://addons/dho_joypad/dho_joypad.gd"


func _enable_plugin() -> void:
	self.add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)


func _disable_plugin() -> void:
	self.remove_autoload_singleton(AUTOLOAD_NAME)


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

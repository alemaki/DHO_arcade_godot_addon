@tool
extends EditorPlugin

const DHO_AUTOLOAD_NAME: String = "DhoJoypad"
const DHO_AUTOLOAD_PATH: String = "res://addons/dho_joypad/scripts/dho_joypad.gd"
const QUIT_AUTOLOAD_NAME: String = "QuitScene"
const QUIT_AUTOLOAD_PATH: String = "res://addons/dho_joypad/scenes/dho_exit_trigger.tscn"

#TODO: create support for 2 players.
func create_joypad_button_event(button: JoyButton, device: int = -1) -> InputEventJoypadButton:
	var event := InputEventJoypadButton.new()
	event.device = device
	event.button_index = button
	event.pressed = true
	return event

func has_joypad_event(events: Array, ev: InputEventJoypadButton) -> bool:
	for existing: InputEvent in events:
		if existing is InputEventJoypadButton:
			if existing.button_index == ev.button_index and existing.device == ev.device:
				return true
	return false

func register_input_actions() -> void:
	for button: DHOJoypad.BUTTON in DHOJoypad.BUTTON_INFORMATION:
		var info: DHOButtonInformation = DHOJoypad.BUTTON_INFORMATION[button]
		if info.input_action.is_empty():
			push_warning("No mapping for DHOButton: " + info.button_name)
			continue
		var setting_path: String = "input/" + info.input_action
		var action: Variant = ProjectSettings.get_setting(setting_path)
		if action == null:
			action = { "deadzone": 0, "events": [] }
		var event := create_joypad_button_event(info.joy_button)
		if not has_joypad_event(action.events, event):
			action.events.append(event)
		ProjectSettings.set_setting(setting_path, action)
	ProjectSettings.save()

func _enable_plugin() -> void:
	self.add_autoload_singleton(DHO_AUTOLOAD_NAME, DHO_AUTOLOAD_PATH)
	self.add_autoload_singleton(QUIT_AUTOLOAD_NAME, QUIT_AUTOLOAD_PATH)
	register_input_actions()

func _disable_plugin() -> void:
	self.remove_autoload_singleton(DHO_AUTOLOAD_NAME)
	self.remove_autoload_singleton(QUIT_AUTOLOAD_NAME)

func _enter_tree() -> void:
	pass


func _exit_tree() -> void:
	pass

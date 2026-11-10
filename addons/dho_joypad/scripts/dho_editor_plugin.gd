# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

@tool
extends EditorPlugin

# Currently fixed but too lazy to think of a better way to map the joystick
const DEVICE_NAME_SUFFIX: String = "_device_"
const DHO_AUTOLOAD_NAME: String = "DhoJoypad"
const DHO_AUTOLOAD_PATH: String = "res://addons/dho_joypad/scripts/dho_joypad.gd"
const QUIT_AUTOLOAD_NAME: String = "QuitScene"
const QUIT_AUTOLOAD_PATH: String = "res://addons/dho_joypad/scenes/dho_exit_trigger.tscn"

# -1 means all devices. Other joypad devices are registered from 0 to 8.
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

func get_action_setting_path(info: DHOButtonInformation, device: int) -> String:
	assert(not info.input_action.is_empty())
	var setting_path = "input/"+ info.input_action
	if device >= 0:
		setting_path += DEVICE_NAME_SUFFIX + str(device)
	return setting_path

func get_action_setting(setting_path: String) -> Variant:
	var action: Variant = ProjectSettings.get_setting(setting_path)
	if action == null:
		return { "deadzone": 0, "events": [] }
	# Mutating it in place makes makes ProjectSettings.save() skips it. So copy and then set.
	return (action as Dictionary).duplicate(true)

func register_input_actions() -> void:
	for device in range(-1, DHOJoypad.MAX_DEVICES_HANDLED):
		for button: DHOJoypad.BUTTON in DHOJoypad.BUTTON_INFORMATION:
			var info: DHOButtonInformation = DHOJoypad.BUTTON_INFORMATION[button]
			var setting_path := self.get_action_setting_path(info, device)
			var action := get_action_setting(setting_path)
			var event := create_joypad_button_event(info.joy_button, device)
			if not has_joypad_event(action.events, event):
				action.events.append(event)
			ProjectSettings.set_setting(setting_path, action)
	ProjectSettings.save() 
	#TODO: REGISTER LEFT, RIGHT, UP and DOWN ACTIONS IMPORTANTEEEE

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

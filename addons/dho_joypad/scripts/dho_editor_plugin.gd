# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin.
# It is not intended to be used in your game. 
# Make of that what you will.

@tool
extends EditorPlugin

const TRANSLATIONS_SETTING: String = "internationalization/locale/translations"
const TRANSLATION_PATH_EN: String = "res://addons/dho_joypad/language/dho_arcade_plugin_translations.en.translation"
const TRANSLATION_PATH_BG: String = "res://addons/dho_joypad/language/dho_arcade_plugin_translations.bg.translation"
const TRANSLATION_PATHS: PackedStringArray = [
	TRANSLATION_PATH_EN,
	TRANSLATION_PATH_BG
]

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

# -1 means all devices. Other joypad devices are registered from 0 to 8.
func create_joypad_axis_event(axis: JoyAxis, axis_value: float, device: int = -1) -> InputEventJoypadMotion:
	var event := InputEventJoypadMotion.new()
	event.device = device
	event.axis = axis
	event.axis_value = axis_value
	# event.pressed = true # TODO: is this relevant?
	return event

func has_joypad_button_event(events: Array, ev: InputEventJoypadButton) -> bool:
	for existing: InputEvent in events:
		if existing is InputEventJoypadButton:
			if existing.button_index == ev.button_index and existing.device == ev.device:
				return true
	return false

func has_joypad_axis_event(events: Array, ev: InputEventJoypadMotion) -> bool:
	for existing: InputEvent in events:
		if existing is InputEventJoypadMotion:
			if existing.axis == ev.axis\
				and is_equal_approx(existing.axis_value, ev.axis_value)\
				and existing.device == ev.device:
				return true
	return false

func get_action_setting_path(input_action: String, device: int) -> String:
	assert(not input_action.is_empty())
	var setting_path = "input/"+ input_action
	if device >= 0:
		setting_path += DEVICE_NAME_SUFFIX + str(device)
	return setting_path

func get_action_setting(setting_path: String) -> Variant:
	var action: Variant = ProjectSettings.get_setting(setting_path)
	if action == null:
		return { "deadzone": 0.5, "events": [] }
	# Mutating it in place makes makes ProjectSettings.save() skips it. So copy and then set.
	return (action as Dictionary).duplicate(true)

func change_settings_for_buttons_on_device(device: int) -> void:
	for button: DHOJoypad.BUTTON in DHOJoypad.BUTTON_INFORMATION:
		var info: DHOButtonInformation = DHOJoypad.BUTTON_INFORMATION[button]
		var setting_path := self.get_action_setting_path(info.input_action, device)
		var action := get_action_setting(setting_path)
		var event := create_joypad_button_event(info.joy_button, device)
		if not has_joypad_button_event(action.events, event):
			action.events.append(event)
		ProjectSettings.set_setting(setting_path, action)

func change_settings_for_axes_on_device(device: int) -> void:
	for axis: DHOJoystickAxisInformation in DHOJoypad.AXIS_INFORMATION:
		var setting_path := self.get_action_setting_path(axis.input_action, device)
		var action := get_action_setting(setting_path)
		var event := create_joypad_axis_event(axis.joy_axis, axis.axis_value, device)
		if not has_joypad_axis_event(action.events, event):
			action.events.append(event)
		ProjectSettings.set_setting(setting_path, action)

func register_input_actions() -> void:
	for device in range(-1, DHOJoypad.MAX_DEVICES_HANDLED):
		change_settings_for_buttons_on_device(device)
		change_settings_for_axes_on_device(device)
	ProjectSettings.save()

func register_translations() -> void:
	var current: PackedStringArray = ProjectSettings.get_setting(TRANSLATIONS_SETTING, PackedStringArray())
	var updated: PackedStringArray = current.duplicate()
	for path in TRANSLATION_PATHS:
		if not updated.has(path):
			updated.append(path)
	ProjectSettings.set_setting(TRANSLATIONS_SETTING, updated)

func unregister_translations() -> void:
	var current: PackedStringArray = ProjectSettings.get_setting(TRANSLATIONS_SETTING, PackedStringArray())
	var updated := PackedStringArray()
	for path in current:
		if not TRANSLATION_PATHS.has(path):
			updated.append(path)
	ProjectSettings.set_setting(TRANSLATIONS_SETTING, updated)

func _enable_plugin() -> void:
	self.add_autoload_singleton(DHO_AUTOLOAD_NAME, DHO_AUTOLOAD_PATH)
	self.add_autoload_singleton(QUIT_AUTOLOAD_NAME, QUIT_AUTOLOAD_PATH)
	register_translations()
	register_input_actions()
	ProjectSettings.save()

func _disable_plugin() -> void:
	self.remove_autoload_singleton(DHO_AUTOLOAD_NAME)
	self.remove_autoload_singleton(QUIT_AUTOLOAD_NAME)
	unregister_translations()
	ProjectSettings.save()

func _enter_tree() -> void:
	pass


func _exit_tree() -> void:
	pass

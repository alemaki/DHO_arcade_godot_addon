# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin.
# It is not intended to be used in your game. 
# Make of that what you will.

@tool
extends EditorPlugin
class_name DHOEditorPlugin

const MAX_DEVICES_HANDLED_SETTING_PATH := DHOJoypad.MAX_DEVICES_HANDLED_SETTING_PATH
const MAX_DEVICES_HANDLED_DEFAULT_VALUE := DHOJoypad.MAX_DEVICES_HANDLED_DEFAULT_VALUE
const GAME_START_SCENE_SETTING_PATH := DHOSceneManager.GAME_START_SCENE_SETTING_PATH
const GAME_START_SCENE_DEFAULT_VALUE := DHOSceneManager.GAME_START_SCENE_DEFAULT_VALUE
const IS_ZERO_SCORE_SAVED_SETTING_PATH := DHOPlayerDataHolder.IS_ZERO_SCORE_SAVED_SETTING_PATH
const IS_ZERO_SCORE_SAVED_DEFAULT_VALUE := DHOPlayerDataHolder.IS_ZERO_SCORE_SAVED_DEFAULT_VALUE

const TRANSLATIONS_SETTING: String = "internationalization/locale/translations"
const TRANSLATION_PATH_EN: String = "res://addons/dho_arcade_addon/language/dho_arcade_plugin_translations.en.translation"
const TRANSLATION_PATH_BG: String = "res://addons/dho_arcade_addon/language/dho_arcade_plugin_translations.bg.translation"
const TRANSLATION_PATHS: PackedStringArray = [
	TRANSLATION_PATH_EN,
	TRANSLATION_PATH_BG
]

const DEVICE_NAME_SUFFIX: String = "_device_"
const DHO_AUTOLOAD_NAME: String = "DhoJoypad"
const DHO_AUTOLOAD_PATH: String = "res://addons/dho_arcade_addon/scripts/dho_joypad.gd"
const EXIT_TRIGGER_AUTOLOAD_NAME: String = "ExitTrigger"
const EXIT_TRIGGER_AUTOLOAD_PATH: String = "res://addons/dho_arcade_addon/scenes/dho_exit_trigger.tscn"

var _last_max_device_handled: int = DHOJoypad.get_max_devices_handled()

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
	# event.pressed = true # Is this relevant? doesn't come up in tests.
	return event

func has_joypad_button_event(events: Array, ev: InputEventJoypadButton) -> bool:
	for existing: InputEvent in events:
		if existing is InputEventJoypadButton:
			if existing.button_index == ev.button_index and existing.device == ev.device:
				return true
	return false

func has_joypad_axis_event(events: Array, ev: InputEventJoypadMotion) -> bool:
	for existing: InputEvent in events:
		if existing is not InputEventJoypadMotion:
			continue
		if (
				existing.axis == ev.axis
				and is_equal_approx(existing.axis_value, ev.axis_value)
				and existing.device == ev.device
		):
			return true
	return false

func get_action_setting_path(input_action: String, device: int) -> String:
	assert(not input_action.is_empty())
	var setting_path := "input/"+ input_action
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
		var action := self.get_action_setting(setting_path)
		var event := self.create_joypad_button_event(info.joy_button, device)
		if not self.has_joypad_button_event(action.events, event):
			action.events.append(event)
		ProjectSettings.set_setting(setting_path, action)

func change_settings_for_axes_on_device(device: int) -> void:
	for axis: DHOJoystickAxisInformation in DHOJoypad.AXIS_INFORMATION:
		var setting_path := self.get_action_setting_path(axis.input_action, device)
		var action := self.get_action_setting(setting_path)
		var event := self.create_joypad_axis_event(axis.joy_axis, axis.axis_value, device)
		if not self.has_joypad_axis_event(action.events, event):
			action.events.append(event)
		ProjectSettings.set_setting(setting_path, action)

func register_input_actions() -> void:
	for device in range(-1, DHOJoypad.get_max_devices_handled()):
		change_settings_for_buttons_on_device(device)
		change_settings_for_axes_on_device(device)

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

func register_plugin_settings() -> void:
	# Game start scene setting
	if not ProjectSettings.has_setting(GAME_START_SCENE_SETTING_PATH):
		ProjectSettings.set_setting(GAME_START_SCENE_SETTING_PATH, GAME_START_SCENE_DEFAULT_VALUE)
	ProjectSettings.add_property_info({
		"name": GAME_START_SCENE_SETTING_PATH,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "*.tscn",
	})
	ProjectSettings.set_initial_value(GAME_START_SCENE_SETTING_PATH, GAME_START_SCENE_DEFAULT_VALUE)
	# Is zero setting
	if not ProjectSettings.has_setting(IS_ZERO_SCORE_SAVED_SETTING_PATH):
		ProjectSettings.set_setting(
				IS_ZERO_SCORE_SAVED_SETTING_PATH,
				IS_ZERO_SCORE_SAVED_DEFAULT_VALUE
			)
	ProjectSettings.add_property_info({
		"name": IS_ZERO_SCORE_SAVED_SETTING_PATH,
		"type": TYPE_BOOL,
	})
	ProjectSettings.set_initial_value(
			IS_ZERO_SCORE_SAVED_SETTING_PATH,
			IS_ZERO_SCORE_SAVED_DEFAULT_VALUE
		)
	# Max devices handled.
	if not ProjectSettings.has_setting(MAX_DEVICES_HANDLED_SETTING_PATH):
		ProjectSettings.set_setting(
				MAX_DEVICES_HANDLED_SETTING_PATH,
				MAX_DEVICES_HANDLED_DEFAULT_VALUE
			)
	ProjectSettings.add_property_info({
		"name": MAX_DEVICES_HANDLED_SETTING_PATH,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,8,1"
	})
	ProjectSettings.set_initial_value(
			MAX_DEVICES_HANDLED_SETTING_PATH,
			MAX_DEVICES_HANDLED_DEFAULT_VALUE
		)

func _on_settings_changed() -> void:
	## NOTE: (to self) do not remove input actions if max is reduced. That would delete user
	## defined input mappings, which might be bad.
	if self._last_max_device_handled == DHOJoypad.get_max_devices_handled():
		return
	self._last_max_device_handled = DHOJoypad.get_max_devices_handled()
	register_input_actions()
	ProjectSettings.save()

func _enable_plugin() -> void:
	register_plugin_settings()
	self.add_autoload_singleton(DHO_AUTOLOAD_NAME, DHO_AUTOLOAD_PATH)
	self.add_autoload_singleton(EXIT_TRIGGER_AUTOLOAD_NAME, EXIT_TRIGGER_AUTOLOAD_PATH)
	register_translations()
	register_input_actions()
	ProjectSettings.save()

func _disable_plugin() -> void:
	self.remove_autoload_singleton(DHO_AUTOLOAD_NAME)
	self.remove_autoload_singleton(EXIT_TRIGGER_AUTOLOAD_NAME)
	unregister_translations()
	# No unregister for other settings so they can be saved for possible reload.
	ProjectSettings.save()

func _enter_tree() -> void:
	# TODO: if the default value wasn't changed is the setting saved or not in project.godot?
	register_plugin_settings()
	ProjectSettings.settings_changed.connect(self._on_settings_changed)

func _exit_tree() -> void:
	return

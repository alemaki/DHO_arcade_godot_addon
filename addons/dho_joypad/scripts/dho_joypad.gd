# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

@tool
extends Node
# You know... As in DevHubOne
class_name DHOJoypad
# NOTE: The documentation below is for any godot version from 4.x <= 4.8.
# It might be compatible for future versions or might not be. ¯\_(ツ)_/¯
#
# To learn how best to use the DevHubOne joypad, please read the designated documentation.
# The code part of this class might be or might not be relevant for you. Depends on how deep of an
# implementation you want to create with the joypad.
#
# WARNING: This node is autoloaded by the plugin. Disabling the autoload of this node (or disabling
# the plugin) will BREAK the joypad test scene provided by this plugin.
# You can see the autoloads in Project settings -> Globals.
#
# NOTE: The important sections are: BUTTONS and JOYSTICK

""" -------------------------------------------------------------------------------------------- """
""" SECTION: DEVICE CONTEXTS """
""" -------------------------------------------------------------------------------------------- """
# TODO: Think of a better way to handle multiple devices.
# NOTE: Documentation for this section ends here.

## Increase value as you like. NOTE: If you are using other joypads in addition to the devhubone's you
## might need to increase this value on demand.
const MAX_DEVICES_HANDLED: int = 2

## Context for the joypad measurements.
class _DHOJoypadContext extends Object:
	var device: int = 0
	## Will be generated at _init
	var button_contexts: Dictionary[BUTTON, ButtonContext] = {}
	var left_joystick_X_axis: float = 0.
	var left_joystick_Y_axis: float = 0.
	
	func _init() -> void:
		for button in BUTTON.values():
			self.button_contexts[button] = ButtonContext.new()

var _device_contexts: Dictionary[int, _DHOJoypadContext] = {}

func is_device_valid(device: int) -> bool:
	if device >= self.MAX_DEVICES_HANDLED:
		return false
	return true

""" -------------------------------------------------------------------------------------------- """
""" SECTION: INPUT ACTIONS (INPUT MAP) """
""" -------------------------------------------------------------------------------------------- """
# NOTE: If you are going to use a second device - any mention of any input actions below will be a
# descripton for the first device that connects. The plugin itself creates those actions for you to
# use. Each input action will have it's mirror for a second device with the same name with appended
# "_device_1" (devices are 0-counted) string at the end. For example: "ui_select" is the input
# action for device 0 (the main device) and device 1 (the second device) will have an action 
# "ui_select_device_1" mapped to it, "ui_left" for device 0 and "ui_left_device_1" for device 1, etc.
#
# WARNING: Deleting those actions will require you to reload the plugin to have them again.
# Otherwise you can create your own input actions and map them yourself. You are not required to
# use the ones provided in the plugin. The test scene for the joypad works with the raw input from
# this node and won't break if the defaults ahve been removed. However the asset scenes provided in
# this plugin work with input actions, so yo will have to edit them and include your own actions.
#
# If you wish to create a game that works both with keyboard and the DHO's joypad you can map your
# keyboard variants to those actions.
#
# NOTE: Documentation for this section ends here.

""" -------------------------------------------------------------------------------------------- """
""" SECTION: BUTTONS """
""" -------------------------------------------------------------------------------------------- """
# The buttons are as straight forward as it goes. The plugin will create input mappings for you to 
# capture in your game:
# "ui_select"	: the A button
# "ui_back"		: the B button		# TODO: create interaction between "ui_back" and control nodes?
# "ui_c"		: the C button
# "ui_d"		: the D button
# "ui_e"		: the E button
# "ui_f"		: the F button
# "ui_start"	: the Play (Left) button
# "ui_menu"		: the Exit (Right) button
#
# You can also create your own actions with mappngs for DHO's buttons like this:
# A		: Joypad Button 3 (Top Action, Sony Triangle, Xbox Y, Nintendo X) - All devices
# B		: Joypad Button 1 (Right Action, Sony Circle, Xbox B, Nintendo A) - All devices
# C		: Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B) - All devices
# D		: Joypad Button 2 (Left Action, Sony Square, Xbox X, Nintendo Y) - All devices
# E		: Joypad Button 9 (Left Shoulder, Sony L1, Xbox LB)
# F		: Joypad Button 10 (Right Shoulder, Sony R1, Xbox RB)
# PLAY	: Joypad Button 6 (Start, Xbox Menu, Nintendo +)
# EXIT	: Joypad Button 4 (Back, Sony Select, Xbox Back, Nintendo -)
#
# NOTE: I recommend using the defaults since they are better integrated in the engine and even
# have interactions with the UI.
#
# Optionaly you can capture input from this node like this:
# DhoJoypad.dho_button_pressed.connect(<your function>)
# DhoJoypad.dho_button_released.connect(<your function>)
# There is also a small API which can also by accessed like this:
# DhoJoypad.is_button_pressed(<button>, <device number>)
# DhoJoypad.get_button_hold_time(<button>, <device number>)
# See the implementations below. They only work for joypads, keep in mind.
#
# NOTE: Documentation for this section ends here.

signal dho_button_pressed(button: DHOJoypad.BUTTON, device: int)
signal dho_button_released(button: DHOJoypad.BUTTON, device: int)

enum BUTTON {
	A,
	B,
	C,
	D,
	E,
	F,
	PLAY,
	EXIT
}

const BUTTON_INFORMATION: Dictionary[BUTTON, DHOButtonInformation] = {
	DHOJoypad.BUTTON.A: preload("res://addons/dho_joypad/resources/buttons/dho_button_a.tres"),
	DHOJoypad.BUTTON.B: preload("res://addons/dho_joypad/resources/buttons/dho_button_b.tres"),
	DHOJoypad.BUTTON.C: preload("res://addons/dho_joypad/resources/buttons/dho_button_c.tres"),
	DHOJoypad.BUTTON.D: preload("res://addons/dho_joypad/resources/buttons/dho_button_d.tres"),
	DHOJoypad.BUTTON.E: preload("res://addons/dho_joypad/resources/buttons/dho_button_e.tres"),
	DHOJoypad.BUTTON.F: preload("res://addons/dho_joypad/resources/buttons/dho_button_f.tres"),
	DHOJoypad.BUTTON.PLAY: preload("res://addons/dho_joypad/resources/buttons/dho_button_play.tres"),
	DHOJoypad.BUTTON.EXIT: preload("res://addons/dho_joypad/resources/buttons/dho_button_exit.tres"),
}

# TODO: generate programatically
const EVENT_TRIGGER_BUTTONS: Dictionary[JoyButton, BUTTON] = {
	JOY_BUTTON_Y:				DHOJoypad.BUTTON.A,
	JOY_BUTTON_B:				DHOJoypad.BUTTON.B,
	JOY_BUTTON_A:				DHOJoypad.BUTTON.C,
	JOY_BUTTON_X:				DHOJoypad.BUTTON.D,
	JOY_BUTTON_LEFT_SHOULDER:	DHOJoypad.BUTTON.E,
	JOY_BUTTON_RIGHT_SHOULDER:	DHOJoypad.BUTTON.F,
	JOY_BUTTON_START:			DHOJoypad.BUTTON.PLAY,
	JOY_BUTTON_BACK:			DHOJoypad.BUTTON.EXIT,
}

class ButtonContext extends RefCounted:
	## If currently pressed
	var is_pressed: bool = false
	## Engine time in which the press started in ms
	var press_started: float = 0.

## Param device = -1 for any device.
func is_button_pressed(button: BUTTON, device: int = -1) -> bool:
	assert(self.is_device_valid(device))
	if device < 0:
		for device_context in self._device_contexts.values():
			if  device_context.button_contexts[button].is_pressed:
				return true
	else:
		return self._device_contexts[device].button_contexts[button].is_pressed
	return false

## Returns 0 if button is not held. Defaults to device 0 if param device = -1.
func get_button_hold_duration_msec(button: BUTTON, device: int = -1) -> float:
	assert(self.is_device_valid(device))
	if device < 0:
		device = 0
	if not self._device_contexts[device].button_contexts[button].is_pressed:
		return 0.
	return Time.get_ticks_msec()\
		 - self._device_contexts[device].button_contexts[button].press_started

## Returns 0 if button is not held. Defaults to device 0 if param device = -1.
func get_button_hold_duration_sec(button: BUTTON, device: int = -1) -> float:
	return self.get_button_hold_duration_msec(button, device) / 1000.

## Returns last held time for the button (includes current time if currently held).
## Defaults to device 0 if param device = -1.
func get_button_last_held_time_msec(button: BUTTON, device: int = -1) -> float:
	assert(self.is_device_valid(device))
	if device < 0:
		device = 0
	return Time.get_ticks_msec()\
		 - self._device_contexts[device].button_contexts[button].press_started

## Returns last held time for the button (includes current time if currently held).
## Defaults to device 0 if param device = -1.
func get_button_last_held_time_sec(button: BUTTON, device: int = -1) -> float:
	return self.get_button_last_held_time_msec(button, device) / 1000.

## Handle for event.
func _button_pressed(button: BUTTON, device: int) -> void:
	# Signal for this button should fire only once when it's pressed.
	self.dho_button_pressed.emit(button, device)
	self._device_contexts[device].button_contexts[button].press_started = Time.get_ticks_msec()
	self._device_contexts[device].button_contexts[button].is_pressed = true

## Handle for event.
func _button_released(button: BUTTON, device: int) -> void:
	# Signal for this button should fire only once when it's released.
	self.dho_button_released.emit(button, device)
	self._device_contexts[device].button_contexts[button].is_pressed = false

""" -------------------------------------------------------------------------------------------- """
""" SECTION: JOYSTICK """
""" -------------------------------------------------------------------------------------------- """
# NOTE: The devhubone joystick is captured by the default godot action input mappings:
# ui_left, ui_right, ui_up, ui_down. I am sure those are descriptive enough.
# They will be dewly registered by the plugin if not already registered.
#
# New projects in Godot have them ON by default. You can see the godot built-in actions
# by going into: Project -> Project Settings -> Input Map -> Show Built-In-Actions.
# Feel free to define yours if you want to. The instructions are below.
#
# You can capture the joystick events by defining your own action names 
# (for example 'process_[direction]') and setting the input capture to:
# left	: Joypad Axis 0 - (Left stick Left, Joystick 0 Left)
# right	: Joypad Axis 0 + (Left stick Right, Joystick 0 Right)
# up	: Joypad Axis 1 - (Left stick Up, Joystick 0 Up)
# down	: Joypad Axis 1 + (Left stick Down, Joystick 0 Down)
#
# NOTE: I recommend using the defaults since they are better integrated in the engine and even
# have interactions with the UI.
# 
# To get input information just capture the mappings:
# var axis_X: float = Input.get_axis("ui_left, ui_right")
# var axis_Y: float = Input.get_axis("ui_up, ui_down")
#
# Feel free to get the direct input with:
# var input_left: float = Input.get_action_strength("ui_left") # for example
#
# You can also use this class' API which, keep in mind, only works for joypads:
# DhoJoypad.get_input_vector()
# DhoJoypad.get_normalized_input_vector()
# See the implementations below.
#
# WARNING: DO NOT USE Input.get_vector like this:
# var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
# As of currently (06.11.2026), joypad inputs will result with some error along the axis
# that is not pressed when calling the Input.get_vector with combination of keyboard input.
# Issue to resolve: https://github.com/godotengine/godot/issues/90515#issuecomment-2616602880
#
# NOTE: Documentation for this section ends here.

## Emits normalized input
signal dho_joystick_changed(vector: Vector2, device: int)

# This function defaults to device 0 in device = -1, because not sure how I am supposed to handle
# multiple device inputs for axes.
## NOTE: The function below does not return normalised input.
## I am using only raw input here so the devhubone_test_scene will work regardless of input mappings.
## If device = -1 it will default to 0.
func get_input_vector(device: int) -> Vector2:
	assert(self.is_device_valid(device))
	if device == -1:
		device = 0
	return Vector2(
		self._device_context[device].left_joystick_X_axis, 
		self._device_context[device].left_joystick_Y_axis
	)

## If device = -1 it will default to 0.
func get_normalized_input_vector(device: int = -1) -> Vector2:
	return get_input_vector(device).normalized()

func _axis_X_changed(axis_value: float, device: int) -> void:
	self._device_context[device].left_joystick_X_axis = axis_value
	self.dho_joystick_changed.emit(self.get_normalized_input_vector(device), device)

func _axis_Y_changed(axis_value: float, device: int) -> void:
	self._device_context[device].left_joystick_X_axis = axis_value
	self.dho_joystick_changed.emit(self.get_normalized_input_vector(device), device)

""" -------------------------------------------------------------------------------------------- """
""" SECTION: NODE FUNCTIONS """
""" -------------------------------------------------------------------------------------------- """

func _init() -> void:
	for device in self.MAX_DEVICES_HANDLED:
		var device_context := _DHOJoypadContext.new()
		device_context.device = device
		self._device_contexts[device] = device_context

func _process(_delta: float):
	pass

func _ready():
	pass

""" -------------------------------------------------------------------------------------------- """
""" SECTION: INPUT HANDLING """
""" -------------------------------------------------------------------------------------------- """
# The devhubone joystick can also be captured by using the general joypad input events.
# Take a look at _input() to see how the input events can be handled.
#
# NOTE: Documentation for this section ends here.

func _input(event: InputEvent) -> void:
	if not self.is_device_valid(event.device):
		return
	if event is InputEventJoypadButton:
		if event.is_pressed() && EVENT_TRIGGER_BUTTONS.has(event.get_button_index()):
			self._button_pressed(EVENT_TRIGGER_BUTTONS[event.get_button_index()], event.device)
		elif event.is_released() && EVENT_TRIGGER_BUTTONS.has(event.get_button_index()):
			self._button_released(EVENT_TRIGGER_BUTTONS[event.get_button_index()], event.device)
	
	if event is InputEventJoypadMotion:
		if event.axis == 0:
			self._axis_X_changed(event.axis_value, event.device)
		elif event.axis == 1:
			self._axis_Y_changed(event.axis_value, event.device)

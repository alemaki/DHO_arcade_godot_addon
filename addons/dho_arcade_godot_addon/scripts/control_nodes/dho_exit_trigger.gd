# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

## The scene that contains this script (dho_exit_trigger.tscn) will be autoloaded by the plugin.
## It's an UI Node that stays hidden until the exit button is pressed. If the exit button is pressed
## twice, this scene will trigger an exit of the game.
## WARNING: It is required for DevHubOne's arcade!
extends Control
class_name DHOExitTrigger

# Measured in seconds
@export var second_press_trigger_time_window: float = 1.
var pressed_once: bool = false
# Children will be removed so they will not be processed in the scene and only added back on 
# exit button pressed.
var hidden_children: Array[Node] = []

func hide_children() -> void:
	self.hidden_children = self.get_children()
	for child in self.get_children():
		self.remove_child(child)

func show_children() -> void:
	for child in self.hidden_children:
		self.add_child(child)

func _ready() -> void:
	self.hide_children()
	self._set_language()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_exit"):
		self._on_button_pressed()

## Since this node is autoloaded I will set language here. not the best idea but good enough.
func _set_language() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	for arg in args:
		if arg.to_lower().begins_with("-language="):
			var language: String = arg.trim_prefix("-language=")
			if language in ["en", "bg"]:
				TranslationServer.set_locale(language)
			break

func _on_button_pressed() -> void:
	if not pressed_once:
		self.pressed_once = true
		self.get_tree()\
				.create_timer(second_press_trigger_time_window)\
				.timeout\
				.connect(self._on_first_press_timeout)
		self.show_children()
	else:
		self.get_tree().quit()

func _on_first_press_timeout() -> void:
	self.hide_children()
	self.pressed_once = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for child in self.hidden_children:
			child.queue_free()

# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

## Every scene root in your game must inherit from this node (or be it) for you to use
## DHOSceneManager to change scenes with passing the contex around in your game.
## If you do not want to pass context in your scenes, you can jsut pass a new context whenever you 
## switch to one of the plugin's scene and ignore this class.
extends Control
class_name DHOScene

@export var dho_context: DHOSceneContext = null

func _ready() -> void:
	assert(dho_context != null)

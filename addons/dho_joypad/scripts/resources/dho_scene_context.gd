# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

## A resource for managing inforamtion between scenes.
extends Resource
class_name DHOSceneContext

## WARNING: The data fields below are required for the plugin's scenes.
@export var player_info: DHOPlayerScoreData = DHOPlayerScoreData.new()
@export var is_score_saved: bool = false
@export var is_win: bool = false
## Add other information for your scenes as you see fit. Or even better: extend this class.

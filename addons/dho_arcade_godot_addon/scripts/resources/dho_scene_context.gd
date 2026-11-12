# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.

## A resource for managing information between scenes. Use this in your scenes paired with [DHOScene]
## to pass the game information around scenes. You will have to pass this to the plugin's scenes
## so they will work properly.
extends Resource
class_name DHOSceneContext

# WARNING: The data fields below are required for the plugin's scenes:
# You can edit these in your own scenes to keep track of information then pass it to other 
# DHO scenes from the plugin. They will take care of the information for you.
## How much score did the player get. Keep value between 0 and 999999.
@export_range(0, 999999) var score: int = 0
## Before changing the scene set this to true if player won.
@export var is_win: bool = false 
# Leave these ones alone, they are used elsewhere:
@export var is_score_saved: bool = false # If the player saves his score, used later.
# Add other information for your scenes as you see fit. Or even better: extend this class.

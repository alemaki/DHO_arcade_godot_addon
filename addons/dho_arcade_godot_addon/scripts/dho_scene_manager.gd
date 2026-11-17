# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.

## A static class that contains method for changing scenes for DevHubOne's arcade.
class_name DHOSceneManager

## Leave those as they are
const MAIN_SCENE = "res://addons/dho_arcade_godot_addon/scenes/dho_main.tscn"
const SAVE_SCORE_SCENE: String = "res://addons/dho_arcade_godot_addon/scenes/dho_save_score.tscn"
const WIN_LOSE_SCENE: String = "res://addons/dho_arcade_godot_addon/scenes/dho_win_lose.tscn"
const GAME_START_SCENE_SETTING: String = "DHO/arcade/game_start_scene"
const DEFAULT_GAME_START_SCENE: String = "res://addons/dho_arcade_godot_addon/scenes/dho_joypad_test.tscn"

# NOTE: The switch_to* functions are better tailored for you game design.
# If you do not wish for your game to have 0 scores you can go to `dho_player_data_holder.tscn` and
# change IS_ZERO_SCORE_COUNTED to false.

## Changes the current scene to the score saving scene.[br]
## [param current_node] : Any node from the current scene will do.[br]
## [param score] : The score the player aquired.[br]
## [param is_win]: Whether the player won.[br]
static func switch_to_save_score_scene(
		current_node: Node,
		score: int = 0,
		is_win: bool = false
		) -> Error:
	var context := DHOSceneContext.new()
	context.score = score
	context.is_win = is_win
	return await change_to_dho_scene(current_node, SAVE_SCORE_SCENE, context)

## Changes the current scene to the win/lose scene. Switch to this scene directly if you do not wish
## to save the score of the player. [br]
## [param current_node] : Any node from the current scene will do.[br]
## [param score] : The score the player aquired.[br]
## [param is_win]: Whether the player won.[br]
static func switch_to_win_lose_scene(
		current_node: Node,
		score: int = 0,
		is_win: bool = false
		) -> Error:
	var context := DHOSceneContext.new()
	context.score = score
	context.is_win = is_win
	return await change_to_dho_scene(current_node, WIN_LOSE_SCENE, context)

static func get_game_start_scene_path() -> String:
	return ProjectSettings.get_setting(GAME_START_SCENE_SETTING, DEFAULT_GAME_START_SCENE)

## Changes the current scene to the next and passes the context to that scene. Use this to switch if
## you have a current context. [br]
## [param current_node] : any node from the current scene will do.[br]
## [param to_path] : scene path to change to. The resulting scene MUST inherit [DHOScene][br]
## [param context]: The context to pass to the next scene.[br]
static func change_to_dho_scene(current_node: Node, to_path: String, context: DHOSceneContext) -> Error:
	var tree: SceneTree = current_node.get_tree()
	var new_root: DHOScene = load(to_path).instantiate() as DHOScene
	if new_root == null:
		return Error.ERR_PARSE_ERROR
	new_root.dho_context = context
	var error: Error = tree.change_scene_to_node(new_root)
	if error == OK:
		await tree.scene_changed # await just to be safe
	return error

## Changes the current scene to another scene. Does not require DHOScene. If the result is a 
## DHOScene, a fresh copy of the default context set in the scene will load.
## [param current_node] : any node from the current scene will do.[br]
## [param to_path] : scene path to change to.[br]
static func change_scene_to_path(current_node: Node, to_path: String) -> Error:
	var tree: SceneTree = current_node.get_tree()
	var new_root: Node = load(to_path).instantiate()
	if new_root is DHOScene and new_root.dho_context != null:
		new_root.dho_context = new_root.dho_context.duplicate()
	var error: Error = tree.change_scene_to_node(new_root)
	if error == OK:
		await tree.scene_changed # await just to be safe
	return error

# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.

## A static class that contains method for changing scenes for DevHubOne's arcade.
class_name DHOSceneManager

## Changes the current scene to the next and passes the context to that scene. Use this to switch if
## you have a current context. [br]
## [param current_node] : any node from the current scene will do.[br]
## [param to_path] : scene path to change to. The resulting scene MUST inherit [DHOScene][br]
## [param context]: The context to pass to the next scene.[br]
static func change_scene(current_node: Node, to_path: String, context: DHOSceneContext) -> Error:
	var tree: SceneTree = current_node.get_tree()
	var old_root: Node = tree.get_current_scene()
	var new_root: DHOScene = load(to_path).instantiate() as DHOScene
	if new_root == null:
		return Error.ERR_PARSE_ERROR
	new_root.dho_context = context
	var error: Error = tree.change_scene_to_node(new_root)
	if error == OK:
		await tree.scene_changed # await just to be safe
	return error

## Changes the current scene to the next creates new context for that scene. Use this for restarts
## of the game.[br]
## [param current_node] : any node from the current scene will do.[br]
## [param to_path] : scene path to change to. The resulting scene MUST inherit [DHOScene][br]
## [param score] : Optional. Set the score in a new scene. Otherwise will be set to 0.[br]
static func change_scene_new_context(current_node: Node, to_path: String, score: int = 0) -> Error:
	var context := DHOSceneContext.new()
	context.score = score
	return await change_scene(current_node, to_path, context)

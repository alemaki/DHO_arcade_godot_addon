# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.

## This is used to store, load and save multiple player's information about their score and name.
extends Resource
class_name DHOPlayerDataHolder

const MAX_SCORE_HOLD := 10 # Can hold more than 10 but currently shows just 10, so why bother.
## If 0 score is not counted, the score_saver will skip it. Also the score won't be shown in the 
## win_lose scene of the game.
const IS_ZERO_SCORE_COUNTED := true
@export var player_data_arr: Array[DHOPlayerData]

const PLAYER_DATA_LOCATION: String = "user://score_data.json"
const PLAYER_TMP_DATA_LOCATION: String = "user://score_data_temp.json"

func sort_player_data() -> void:
	self.player_data_arr.sort_custom(DHOPlayerData._bigger_score)

## Adds score and sorts it in. If overflowing - deletes worst score.
## Returns true if new score is added, false if it was too low.
func add_player_data(player_data_to_add: DHOPlayerData) -> bool:
	if (not IS_ZERO_SCORE_COUNTED) and player_data_to_add.score == 0:
		return false
	var score_added: bool = true
	self.player_data_arr.push_back(player_data_to_add)
	self.sort_player_data()
	while self.player_data_arr.size() > MAX_SCORE_HOLD:
		if self.player_data_arr.pop_back() == player_data_to_add:
			score_added = false
	return score_added


## Returns the best best_count scores or all of them if best_count = -1
func get_player_data(best_count: int = -1) -> Array[DHOPlayerData]:
	if best_count == -1:
		return self.player_data_arr.duplicate()
	return self.player_data_arr.slice(0, best_count)

static func load_player_data() -> DHOPlayerDataHolder:
	var result: DHOPlayerDataHolder = DHOPlayerDataHolder.new()
	if not FileAccess.file_exists(PLAYER_DATA_LOCATION):
		return result
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PLAYER_DATA_LOCATION))
	if not (parsed is Array):
		push_warning("DHOPlayerDataHolder: Save file could not be read; scores might be corrupted")
		return result
	var data: Array = parsed
	for dict in data:
		if dict is not Dictionary:
			push_warning("DHOPlayerDataHolder: Player data is not dict; scores might be corrupted: " + str(dict))
			continue
		var player_data: DHOPlayerData = DHOPlayerData.from_dict(dict)
		if player_data == null:
			push_warning("DHOPlayerDataHolder: Player data in save file could not be parsed: " + str(dict))
			continue
		result.add_player_data(player_data)
	# Just in case data was tampered with
	result.sort_player_data()
	return result

func _get_json_str() -> String:
	var json_information: Array[Dictionary] = []
	for data: DHOPlayerData in self.player_data_arr:
		var player_data_dict: Dictionary[String, Variant] = data.to_dict()
		json_information.push_back(player_data_dict)
	return JSON.stringify(json_information, "\t")

func _write_temp_json() -> bool:
	var json_string := self._get_json_str()
	var file := FileAccess.open(PLAYER_TMP_DATA_LOCATION, FileAccess.WRITE)
	if file == null:
		push_error("DHOPlayerDataHolder: Could not open save file: %s" % error_string(FileAccess.get_open_error()))
		return false
	var written: bool = file.store_string(json_string)
	var write_error: Error = file.get_error()
	file.close()	
	if not written or write_error != OK:
		push_error("DHOPlayerDataHolder: Could not write save file; the previous save is unchanged: %s"\
				% error_string(write_error))
		DirAccess.remove_absolute(PLAYER_TMP_DATA_LOCATION)
		return false
	return true

func _rename_temp_json() -> bool:
	var rename_error := DirAccess.rename_absolute(PLAYER_TMP_DATA_LOCATION, PLAYER_DATA_LOCATION)
	if rename_error != OK:
		push_error("DHOPlayerDataHolder: Could not replace save file: %s" % error_string(rename_error))
		DirAccess.remove_absolute(PLAYER_TMP_DATA_LOCATION)
		return false
	return true

func save_player_data() -> bool:
	if not self._write_temp_json() or not self._rename_temp_json():
		return false
	return true

static func is_new_highscore(score: int) -> bool:
	var player_data_holder: DHOPlayerDataHolder = load_player_data()
	if not IS_ZERO_SCORE_COUNTED and score == 0:
		return false
	return player_data_holder.player_data_arr.size() < MAX_SCORE_HOLD\
		or player_data_holder.player_data_arr.back().score < score

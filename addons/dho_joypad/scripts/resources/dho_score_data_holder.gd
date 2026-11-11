# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

## This is used to store, load and save multiple player's information about their score and name.
extends Resource
class_name DHOScoreDataHolder

const MAX_SCORE_HOLD = 10 # Can hold more than 10 but currently shows just 10, so why bother.
@export var player_data: Array[DHOPlayerScoreData]
const PLAYER_DATA_LOCATION: String = "user://score_data.json"
const TEMP_PLAYER_DATA_LOCATION: String = "user://score_data_temp.json"
# TODO: what to do with equal scores?
func sort_scores() -> void:
	self.player_data.sort_custom(DHOPlayerScoreData._bigger_score)

# TODO: remove_score()?? Check score validity? or not responsible.
## Adds score and sorts it in. If overflowing - deletes worst score.
func add_score(score_data: DHOPlayerScoreData) -> bool:
	var score_added: bool = true
	self.player_data.push_back(score_data)
	self.sort_scores()
	while self.player_data.size() > MAX_SCORE_HOLD:
		if self.player_data.pop_back() == score_data:
			score_added = false
	return score_added


## Returns the best best_count scores or all of them if best_count = -1
func get_scores(best_count: int = -1) -> Array[DHOPlayerScoreData]:
	if best_count == -1:
		return self.player_data
	return self.player_data.slice(0, best_count)

static func load_scores() -> DHOScoreDataHolder:
	var result: DHOScoreDataHolder = DHOScoreDataHolder.new()
	if not FileAccess.file_exists(PLAYER_DATA_LOCATION):
		return result
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PLAYER_DATA_LOCATION))
	if not (parsed is Array):
		push_warning("Save file could not be read; scores might be corrupted")
		return result
	var data: Array = parsed
	for dict in data:
		if dict is not Dictionary:
			push_warning("Player data is not dict; scores might be corrupted: " + str(dict))
			continue
		var player_data: DHOPlayerScoreData = DHOPlayerScoreData.from_dict(dict)
		if player_data == null:
			push_warning("Player data in save file could not be parsed: " + str(dict))
			continue
		result.add_score(player_data)
	# Just in case data was tampered with
	result.sort_scores()
	return result

func save_scores() -> bool:
	var json_information: Array[Dictionary] = []
	for data: DHOPlayerScoreData in self.player_data:
		var player_data_dict: Dictionary[String, Variant] = data.to_dict()
		json_information.push_back(player_data_dict)
	var json_string: String = JSON.stringify(json_information, "\t")
	var file := FileAccess.open(TEMP_PLAYER_DATA_LOCATION, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file: %s" % error_string(FileAccess.get_open_error()))
		return false
	var written: bool = file.store_string(json_string)
	var write_error: Error = file.get_error()
	file.close()	
	if not written or write_error != OK:
		push_error("Could not write save file; the previous save is unchanged: %s"\
			% error_string(write_error))
		DirAccess.remove_absolute(TEMP_PLAYER_DATA_LOCATION)
		return false
	var rename_error := DirAccess.rename_absolute(TEMP_PLAYER_DATA_LOCATION, PLAYER_DATA_LOCATION)
	if rename_error != OK:
		push_error("Could not replace save file: %s" % error_string(rename_error))
		return false
	return true
	

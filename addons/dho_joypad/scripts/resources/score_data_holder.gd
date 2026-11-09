extends Resource
class_name ScoreDataHolder

const MAX_SCORE_HOLD = 100 # Idk what devhubone wants but will hold 100 just in case
@export var scores: Array[PlayerScoreData]

# TODO: what to do with equal scores?
func sort_scores() -> void:
	scores.sort_custom(PlayerScoreData._bigger_score)

# TODO: remove_score()?? Check score validity? or not responsible.
## Adds score and sorts it in. If overflowing deletes worst score.
func add_score(score_data: PlayerScoreData) -> void:
	self.scores.push_back(score_data)
	self.sort_scores()
	while self.scores.size() > MAX_SCORE_HOLD:
		scores.pop_back()


## Returns the best best_count scores or all of them if best_count = -1
func get_scores(best_count: int = -1) -> Array[PlayerScoreData]:
	if best_count == -1:
		return scores
	return self.scores.slice(0, best_count)

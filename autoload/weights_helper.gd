class_name WeightHelper
#Хелпер по подбору по весам
static func pick_weighted(dict: Dictionary):
	var total_weight = 0
	for weight in dict.values():
		total_weight += weight

	var rnd = randf() * total_weight
	var cumulative = 0.0

	for key in dict.keys():
		cumulative += dict[key]
		if rnd <= cumulative:
			return key
	return null

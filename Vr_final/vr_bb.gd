extends Node3D

var SCORE = 0

func _on_area_3d_body_entered():
	SCORE += 1
	if SCORE <= 99:
		$lblScore.text = "%d/%d" % SCORE
	else:
		$lblScore.text = "ERROR"

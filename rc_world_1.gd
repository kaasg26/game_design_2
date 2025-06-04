extends Node3D

@onready var audio_player = $AudioStreamPlayer

# Path to the audio file
var audio_file = "res://assets/audio/RCGame.mp3"

func _ready():
	var stream = load(audio_file)
	audio_player.stream = stream
	#audio_player.play()
	
	
func _process(delta):
	pass

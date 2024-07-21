extends AudioStreamPlayer

class_name MusicPlayer

@export var file: String
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_pause_toggled.connect(on_pause_toggled)
	SignalManager.on_audio_set.connect(on_audio_set)

func on_pause_toggled():
	if GlobalManager.is_paused:
		pause()
	else:
		start()
		
func pause():
	stop()

func start():
	play(GlobalManager.current_time + GlobalManager.audio_lead_time)

func on_audio_set():
	stream = GlobalManager.audio_stream
	
	

extends Node

var current_time : float = 0
var is_paused : bool = true
var max_time : float = 60

var play_area : Control

var selected_note : Note

# Editor settings
var move_all: bool = false
var is_edit_mode: bool = true

# Grid
var bpm: float = 120 # Beats per minute
var scroll_speed: float = 360 # Play units per second
var subdivisions: int = 2
var horizontal_divisions: int = 8
var vertical_divisions: int = 12
var is_static_grid: bool = false
var snap_vertical: bool = true
var snap_horizontal: bool = true
var grid_time_offset: float = 0 # The time of the first beat (or any other beat actually)

# MIDI
var midi_speed: float = 60 # Play units per second
var midi_file_path: String
#var selected_midi: MidiNoteObject

# Audio
var audio_stream: AudioStream
var audio_lead_time: float




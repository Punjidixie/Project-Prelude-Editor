extends Node

var current_time : float = 0
var is_paused : bool = true
var max_time : float = 30

var play_area : Control

var selected_note : Note

var move_all : bool = false

var bpm: float = 120 # Beats per minute
var scroll_speed: float = 30 # Play units per second
var subdivisions: int = 1
var horizontal_divisions: int = 1
var vertical_divisions: int = 12
var is_static_grid: bool = false

var time_offset: float = 0 # The time the first beat / chart starts



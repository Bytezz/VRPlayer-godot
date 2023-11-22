extends Node3D

@onready var timer : Timer = get_node("Timer")
@onready var playpause_btn : Button = get_node("SubViewport/MarginContainer/1HBoxContainer/playpause_btn")
@onready var timeline : HSlider = get_node("SubViewport/MarginContainer/1HBoxContainer/timeline")
@onready var time_label : Label = get_node("SubViewport/MarginContainer/1HBoxContainer/time_label")

var player : VideoStreamPlayer = null : set = set_player
var playing : bool = false
var length : int = 0

func play_status(status:bool=false):
	playing = status
	if player != null:
		player.paused = !playing

func get_playing():
	if player:
		playing = player.is_playing() and !player.paused
	else:
		playing = false
	
	return playing

func toggle_playing():
	play_status(!playing)

func set_time(sec:int=0):
	timeline.max_value = length
	timeline.value = sec
	
	time_label.text = "%02d:%02d" % [int(sec/60.0)%60, fmod(sec, 60.0)]
	#time_label.text+="/%02d:%02d" % [int(length/60.0)%60, fmod(length, 60.0)]

func get_time():
	var sec = 0
	var vmax = 0
	
	if player:
		sec = int(player.stream_position)
		#vmax = int(player.get_length) # Does not exist. Workaround follows
		length = 60
		while sec > length:
			length+=60
	
	set_time(sec)

func set_player(new_player):
	player = new_player
	length = 0
	get_time()
	timer.start()

func _on_timer_timeout():
	get_time()

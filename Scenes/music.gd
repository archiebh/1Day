extends Control

var count = 0
var shuffledList
var reallist
var anyplaying = false
onready var track1 = $Track1
onready var track2 = $Track2
onready var track3 = $Track3
onready var lowpass:AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"),0)
func shuffleList(list):
	var shuffledList = []
	var indexList = range(list.size())
	for i in range(list.size()):
		randomize()
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	print(str(shuffledList))
	reallist = shuffledList
	return shuffledList

func play():
	var choose = reallist[count]
	stop()
	if choose == 0:
		track1.play()
	if choose == 1:
		track2.play()
	if choose == 2:
		track3.play()

func setvolume():
	track1.volume_db = global.music
	track2.volume_db = global.music
	track3.volume_db = global.music

func stop():
	track1.stop()
	track2.stop()
	track3.stop()
	
func _process(delta):
	if global.paused == true:
		lowpass.cutoff_hz = 500
	elif global.paused == false:
		lowpass.cutoff_hz = 20500
	if global.isInGame == false:
		stop()
	if global.isInGame == true and count == 0:
		shuffleList([0,1,2])
		setvolume()
		play()
		count = count + 1


# Called when the node enters the scene tree for the first time.



func _on_Track1_finished():
	play()


func _on_Track2_finished():
	play()


func _on_Track3_finished():
	play()

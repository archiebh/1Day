extends Position3D

onready var label = $Label3D
var amount = 0
onready var shrink = $shrink

func _ready():
	label.set_text(str(amount))
	shrink.start()



func _process(delta):
	if label.text_size <  0.4:
		queue_free()


func ShrinkTimeout():
	label.text_size = label.text_size * 0.8

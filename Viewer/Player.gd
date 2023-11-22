extends SubViewport

@onready var Picture : TextureRect = get_node("Picture")
@onready var Video : VideoStreamPlayer = get_node("VideoStreamPlayer")

func init():
	if Picture.texture:
		Picture.show()
		size = Picture.texture.get_size()
	else:
		Picture.hide()
	
	if Video.stream:
		Video.show()
		size = Video.get_video_texture().get_size()
	else:
		Video.hide()
	
	# Monoscopic 360 (2:1)
	if size.y != size.x/2 and size.y < size.x/2:
		size.y = size.x/2

func _ready():
	init()

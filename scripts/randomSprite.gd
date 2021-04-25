extends Sprite

func _init():
    var size = texture.get_size() / 8
    frame = randi() % int(size.x * size.y)

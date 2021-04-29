extends Sprite

export(Resource) var treeData

func _ready():
    offset.y = treeData.groundHeight / 2
    region_rect.size.x = treeData.groundWidth
    region_rect.size.y = treeData.groundHeight

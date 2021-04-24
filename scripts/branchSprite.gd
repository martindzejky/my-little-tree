extends Sprite

# keep updating the size of the sprite based on the size
# of the branch
func _process(delta):
    var root = get_parent()
    assert(root is Branch, "branch sprite does not have branch as parent")

    offset.y = - root.length / 2
    region_rect.size.x = root.thickness
    region_rect.size.y = root.length

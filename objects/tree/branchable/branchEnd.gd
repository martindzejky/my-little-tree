extends Position2D

func _process(delta):
    var parent: Branch = get_parent()
    assert(parent is Branch, "branch end is not in a branch")

    # move the end point to the end of the branch
    position.y = parent.growDirection * parent.length

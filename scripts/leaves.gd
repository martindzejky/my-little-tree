extends Node2D

func _process(delta):
    var parent: Branch = get_parent()
    assert(parent is Branch, "leaves are not in a branch")

    # show or hide the leaves if we are on a leaf branch
    $sprite.visible = parent.isLeaf()

    # move leaves to the end of the branch
    $sprite.position.y = parent.growDirection * parent.length

    # rotate them so they are always straight
    $sprite.rotation_degrees = -parent.rotation_degrees

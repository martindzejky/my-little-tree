extends Node2D

export(NodePath) var branchSpritePath

func _process(delta):
    var parent: Branch = get_parent().get_parent()
    assert(parent is Branch, "leaves are not in a branch")

    # show or hide the leaves if we are on a leaf branch
    $sprite.visible = parent.isLeaf()

    # rotate them so they are always straight
    $sprite.global_rotation_degrees = 0

    # copy the color of the branch sprite
    var branchSprite = get_node(branchSpritePath)
    assert(branchSprite is Sprite, "branch sprite path missing")

    $sprite.modulate = branchSprite.modulate

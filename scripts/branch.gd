extends Node2D
class_name Branch

# direction in which the branch/root grows.
# -1 is for branches growing up
#  1 is for roots growing down
export(int, -1, 1) var growDirection

# if true, the player can grow this branch
export(bool) var playerCanGrow = false

# how long is the branch, this might change in time
export(float) var length

# how big (thick) is the branch, this might change in time
export(float) var thickness

func _process(delta):
    updatePosition()
    updateThickness()


# checks whether this is last branch in the tree
func isLeaf() -> bool:
    return $children.get_child_count() == 0


func updatePosition():
    # update the relative position of this branch based on the length
    # of the parent

    var parent = get_parent()

    # this should be the children node of the parent
    if not parent:
        return

    parent = parent.get_parent()

    # this should be the parent branch
    if not parent:
        return

    if not parent as Branch:
        return

    position.y = parent.growDirection * parent.length

func updateThickness():
    # calculate the thickness based on children
    thickness = 1.2
    for childBranch in $children.get_children():
        # super HACK to avoid taking placeholders into account
        if childBranch.has_node('placeholder'):
            continue

        thickness += childBranch.thickness * 0.5

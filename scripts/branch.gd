extends Node2D
class_name Branch

# direction in which the branch/root grows.
# -1 is for branches growing up
#  1 is for roots growing down
export(int, -1, 1) var growDirection

# if true, the player can grow this branch
export(bool) var playerCanGrow = false

# if true, this branch/root can collect water
export(bool) var canCollectWater = false

# how long is the branch, this might change in time
export(float) var length

# how big (thick) is the branch, this might change in time
export(float) var thickness


func _enter_tree():
    updateThickness()

    # update the thickness of all parents
    var parent = get_parent().get_parent()
    while parent and parent as Branch:
        parent.updateThickness()
        parent = parent.get_parent().get_parent()


func _process(delta):
    updatePosition()


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

    position.y = parent.get_node('end').position.y

# this should be called by children of the branch
func updateThickness():
    # calculate the thickness based on children
    var newThickness = 1.2
    var minThickness = 1
    for childBranch in $children.get_children():
        # super HACK to avoid taking placeholders into account
        if childBranch.has_node('placeholder'):
            continue

        newThickness += childBranch.thickness * 0.5
        minThickness = max(minThickness, childBranch.thickness)

    thickness = max(thickness, max(newThickness, minThickness))

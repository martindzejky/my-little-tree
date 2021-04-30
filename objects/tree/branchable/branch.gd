extends Node2D

# TODO: rename to Branchable
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


var branchParents = 0
var originalRotation


func _enter_tree():
    updateThickness()
    updateBranchParents()

    originalRotation = rotation_degrees


func _process(delta):
    updatePosition()

    # DISABLED because I did not have enough time to tweak this
    # animation and it looked weird...
    # animateSwayInWind()

    # destroy the branch if it overlaps the ground
    if $end.global_position.y * growDirection < 0:
        if not has_node('placeholder'):
            queue_free()


# checks whether this is last branch in the tree
func isLeaf() -> bool:
    return $children.get_child_count() == 0


func animateSwayInWind():
    # only sway branches above ground
    if growDirection >= 0:
        return

    var timeConstant = (OS.get_ticks_msec() as float) / 1000

    # delay branches further up the tree
    timeConstant -= branchParents * 1.5

    rotation_degrees = originalRotation + 2 * sin(timeConstant)


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

    newThickness = max(thickness, max(newThickness, minThickness))

    if abs(thickness - newThickness) > 0.001:
        thickness = newThickness

        # TWEENING!!!
        $tween.stop_all()
        $tween.interpolate_property(
            self, 'thickness',
            newThickness * 1.2, newThickness,
            0.2, # duration
            Tween.TRANS_LINEAR, Tween.EASE_OUT
        )
        $tween.start()

    # ping the parent to update its thickness after a delay,
    # which creates a nice animation
    yield(get_tree().create_timer(0.01), "timeout")

    var parent = get_parent().get_parent()
    if parent and parent as Branch:
        parent.updateThickness()

func updateBranchParents():
    var parent = get_parent().get_parent()
    if parent and parent as Branch:
        branchParents = parent.branchParents + 1

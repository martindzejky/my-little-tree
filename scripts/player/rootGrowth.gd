extends Node2D

export(Resource) var treeData

# placeholder root which is created while a new root
# is grown
export(PackedScene) var rootPlaceholderObject

# root object to grown
export(PackedScene) var rootObject

var isGrowing = false
var placeholder: Branch

func _input(event):

    if event.is_action_pressed('select') and not isGrowing:

        if SelectedRoots.hoveredRoots.size() > 0:
            isGrowing = true
            createPlaceholder()


    if event.is_action_released('select') and isGrowing:
        isGrowing = false
        createRootFromPlaceholder()


    if event.is_action_released('select_cancel') and isGrowing:
        isGrowing = false
        cancelPlaceholder()


func _process(delta):
    if isGrowing and placeholder:
        var targetDistance = get_global_mouse_position() - placeholder.global_position

        placeholder.global_rotation_degrees = rad2deg(targetDistance.angle()) - 90

        # clamp the rotation degrees to prevent sharp turns
        if placeholder.rotation_degrees > 180:
            placeholder.rotation_degrees -= 360
        if placeholder.rotation_degrees < -180:
            placeholder.rotation_degrees += 360

        placeholder.rotation_degrees = clamp(placeholder.rotation_degrees, -treeData.maxGrowthAngle, treeData.maxGrowthAngle)

        # prevent roots from growing upwards
        placeholder.global_rotation_degrees = clamp(placeholder.global_rotation_degrees, -90, 90)

        placeholder.length = min(
            targetDistance.length(),
            treeData.maxGrowthLength
            )


func createPlaceholder():
    # start growing root from the first selected root
    # TODO: this could check if there are multiple and select the bottom one
    #       but ain't nobody got time for dat!

    assert(SelectedRoots.hoveredRoots.size() > 0, 'no hovered roots in createPlaceholder')
    var rootToGrowFrom = SelectedRoots.hoveredRoots[0] as Branch

    assert(rootToGrowFrom is Branch, 'root to grow from is not a branch')

    # can the player actually grow this branch?
    if not rootToGrowFrom.playerCanGrow:
        isGrowing = false
        return

    var children = rootToGrowFrom.get_node('children')

    # check if there's a space to grow another branch
    if children.get_child_count() >= treeData.maxBranchChildren:
        isGrowing = false
        return

    placeholder = rootPlaceholderObject.instance()
    children.add_child(placeholder)



func createRootFromPlaceholder():
    # check the minimum length
    if placeholder.length < treeData.minGrowthLength:
        cancelPlaceholder()
        isGrowing = false
        return

    # check that the rotation is "sufficently different" from existing roots to
    # avoid overlapping roots
    var parentChildren = placeholder.get_parent()
    for child in parentChildren.get_children():
        if child == placeholder:
            continue

        if abs(child.rotation_degrees - placeholder.rotation_degrees) < treeData.minRotationDifference:
            cancelPlaceholder()
            isGrowing = false
            return

    # delete the placeholder and create a proper root from it

    var newRoot = rootObject.instance()
    parentChildren.add_child(newRoot)

    # copy the dimensions and orientation
    newRoot.rotation_degrees = placeholder.rotation_degrees
    newRoot.length = placeholder.length

    # remove the placeholder
    placeholder.queue_free()


func cancelPlaceholder():
    if placeholder:
        placeholder.queue_free()
